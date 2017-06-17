classdef FileCl < handle;
% classdef FileCl < matlab.mixin.Copyable;
%% Documentation
% The FileCl (FileClass) is a class intended to help reading and writing files.
% The class contains two main functions: 
%   - read()
%   - write()
% When read is called with an argument, the filepath given as argument is read.
% When write is called with an argument, the filepath given as argument is written.
% The FileCl can be initialized with a filepath as argument, in which case the function "read" is called directly.
%
% Several "helper" functions are present in this class e.g.: to read different floats or integers on a line, to read a matrix of floats, or read everything as strings. 
% This helper functions are found at the end of the file.
% See examples of child classes like FileCl_FlexInput to see how these helper functions are used to read files.
% 
% The FileCl is an ABSTRACT class, meaning that is contains some properties and methods that need to be implemented by the classes that inherit from it. 
% As it is, the FileCl cannot read/write any files. Only the class that inherit from it and implements its abstract interfaces can read/write files.
% The abstract interface that needs to be implemented by child classes are:
%   - the property typical_extension 
%   - the method read_()
%   - the method write_()
% The underscore after the method names is a usual convention to say: "This is something internal, the user shouldn't call these functions directly". These functions are actually hidden so the user won't see them.
%
% The interest is that the parent class (FileCl) handles most of the things you always have to deal with when you read and write a file: 
%    - checking if the file exist before reading
%    - checking if the file exist before writing and only overwrite if the user has set the property "bReadOnly" to false
%    - create the directory structure necessary if the file to write is in a new location
%    - reading a bunch of floats, ints, strings (see the helper functions)
%    - error handling and reporting at which line in the file does the reading procedure failed.
%
% USAGE
%   See the file _test/Main_Examples.m for some examples.
%   See the file _test/Main_UnitTest.m for some examples.
%   
%   Typical usage:
%     Twr = FileCl_FlexTower('Tower.twr'); % automatically reads the file
%     Twr.D= Twr.D*1.1 ;                   % increasing tower diameter
%     Twr.write('TowerBigger.twr');        % write the file
%
% VERSION and AUTHORS: see LAC SVN repository

properties
    % Public
    bReadOnly = false ;
    filepath;
    filename;
end
properties(SetAccess = private, Hidden = true)
    fid ; 
    line_number;
    pos_previous_line;
    current_filename;
    bVerbose=false;
end
properties(SetAccess = protected, Hidden = true)
    FieldsRequiredForWriting={};
    FieldsRequiredSameSize={};
end
properties(Abstract = true, Hidden=true);
    typical_extension; % need to be initialized by sub class
end

% --------------------------------------------------------------------------------
% --- Main public functions: constructor, read and write
% --------------------------------------------------------------------------------
methods
    function o=FileCl(varargin)
        % Constructor for the FileCl
        % INPUTS:
        %    Nothing
        %    OR
        %    First argument is a filename
        if nargin==0
            o.setFilepath('');
        elseif nargin>=1
            % First argument is filename
            o.setFilepath(varargin{1});
            %o.read();
        else
           % fine, it's up to our children to handle the remaining arguments
        end
    end

    % --------------------------------------------------------------------------------}
    %% --- read 
    % --------------------------------------------------------------------------------{
    function read(o,file_name)
        % Read either the current file or the file given as argument.
        % After reading, the oect is set to readonly, and the filepath matches the one that has been read
        if nargin==2
            o.setFilepath(file_name);
        end
        % --- Check of extension
        o.check_extension();
        %
        o.line_number=0; % line number

        % --- Changing  "current_filename", useful for error reporting
        o.current_filename=o.filepath;

        % --- Checks
        if ~exist(o.filepath,'file')
            error('File does not exist %s',o.filepath);
        end
        try
            % --- Opening file for reading and calling children function read
            o.fid=fopen(o.filepath,'r');
            o.bReadOnly = true ;
            o.read_();
            if o.fid>0; o.fid=fclose(o.fid); end
        catch me
            if o.fid>0; o.fid=fclose(o.fid); end
            fprintf(2,'[FAIL] Problem reading %s, see error below:\n',o.filepath);
            fprintf(2,'%s\n\n',me.message);
            fprintf('Call stack:\n');
            rethrow(me)
        end
    end

    % --------------------------------------------------------------------------------}
    %% --- write 
    % --------------------------------------------------------------------------------{
    function write(o,file_name)
        % Write either the current file or the file given as argument. 
        % The object's "filepath" becomes the one of the file that has been writen
        % The "bReadOnly" attributes should be false if we are writing the file that we read with the same filepath
        % The function verifies that the set of attributes required for writing ("FieldsRequiredForWriting") have been set
        if nargin==1
            file_name=o.filepath;
        end
        if isequal(file_name,o.filepath) && o.bReadOnly
            warning('FileCl object has "bReadOnly" attribute set to true, cannot overwrite %s',o.filepath);
        else
            o.setFilepath(file_name);
            % --- Using lower level function copyTo
            o.copyTo(o.filepath);
            %
        end
    end % function write

    % --------------------------------------------------------------------------------}
    %% --- copyTo 
    % --------------------------------------------------------------------------------{
    function copyTo(o,file_name)
        % copyTo: writes to a specific location

        % --- Changing  "current_filename", useful for error reporting
        o.current_filename=file_name;
        % --- Creating parent dir if needed
        parent_dir=fileparts(file_name);
        if ~isempty(parent_dir) 
            if ~exist(parent_dir,'dir')
                mkdir(parent_dir);
            end
        end
        % --- Check of extension
        o.check_extension(file_name);
        try
            % --- Opening file for writing and calling children function write_
            o.fid=fopen(file_name,'w');
            o.write_();
            o.closeFile();
        catch me
            o.closeFile();
            fprintf('[FAIL] Problem writing %s, see error below:\n',file_name);
            fprintf('%s\n\n',me.message);
            fprintf('Call stack:\n');
            rethrow(me)
        end
        o.current_filename=o.filepath;
    end % function copyTo


    % --------------------------------------------------------------------------------}
    %% --- Setter function for filepath. Filename is automatically set 
    % --------------------------------------------------------------------------------{
    function o=setFilepath(o,s)
        o.filepath     = os_path.abspath(s)       ;
        [~,o.filename] = os_path.split(o.filepath);
    end


    % --------------------------------------------------------------------------------}
    %% --- Test Function 
    % --------------------------------------------------------------------------------{
    function o=test(o,TestFileName)
        % Tries to read a file and write it back and compare the differences
        % If the current object represents a file already read, the read function is not called
        % Otherwise, for the safe of testing, the file is read.
        % Then the file is written.
        % Last the files are compared (in a crude way)

        % Read file if not already done
        if exist('TestFileName','var')
            o.read(TestFileName);
        else
            if isempty(o.filepath)
                error('FileCl Test requires reading first')
            end
        end
        % Defining input and output filenames
        [Dir,Base,Ext]=fileparts(o.filepath);
        filein = o.filepath;
        fileout= os_path.join(Dir,[Base '_out' Ext]);
        % Writing back the current file
        o.write(fileout);
        % Resetting to "input file"
        o.setFilepath(filein);
        % Comparing files
        f1=fileread(filein);
        f2=fileread(fileout);
        b=strcmp(f1,f2);
        if b; s='[ OK ]'; else s='[FAIL]'; end;
        fprintf('%s Read/Write test: %s(%s)\n',s,class(o),o.filename);
        % Deleting out file if test succeeded
        if b; delete(fileout); end;
    end % test


end % public methods







% --------------------------------------------------------------------------------
% ---  Abstract methods to be implemented by children
% --------------------------------------------------------------------------------
% methods(Abstract=true, Access = protected, Hidden = true)
methods(Access = protected, Hidden = true)
    function read_(o)
    end
    function write_(o)
    end
    function closeFile(o)
        if o.fid>0; o.fid=fclose(o.fid); end
    end
end % methods






% --------------------------------------------------------------------------------
% ---  
% --------------------------------------------------------------------------------
methods(Access = protected, Hidden = true)
    % --------------------------------------------------------------------------------
    % ---  
    % --------------------------------------------------------------------------------
    function abort(o,msg)
        if o.fid>0; o.fid=fclose(o.fid); end
        error('Error: %s. Line:%d File:%s',msg,o.line_number,o.current_filename);
    end

    % --------------------------------------------------------------------------------
    % --- Helper function to write 
    % --------------------------------------------------------------------------------
    function check_required_fields(o)
        %  Checks that the fields required for writing are not empty
        if ~isempty(o.FieldsRequiredForWriting)
            MissingFields=o.FieldsRequiredForWriting(cellfun(@(x)isempty(o.(x)),o.FieldsRequiredForWriting));
            if ~isempty(MissingFields) 
                MissingFields=sprintf('%s ',MissingFields{:});
                error(  'To write an object of class %s, the following fields needs to be set: %s',class(o),MissingFields);
            end
        end
    end

    % --------------------------------------------------------------------------------
    % ---  
    % --------------------------------------------------------------------------------
    function check_extension(o,varargin)
        if ~isempty(o.typical_extension)
            if ~isempty(varargin)
                [~,~,ext]=fileparts(varargin{1});
            else
                [~,~,ext]=fileparts(o.filepath);
            end
            if ~isequal(lower(ext),lower(o.typical_extension))
                warning('The extension is not standard. Current: %s / expected: %s',ext,o.typical_extension);
            end
        end
    end



    % --------------------------------------------------------------------------------
    % --- Helper functions to read lines 
    % --------------------------------------------------------------------------------
    function [l] = fgetl(o)
        % Read one line and returns it as a string (like fgetl). 
        % Line_number is increased.
        try
            o.pos_previous_line=ftell(o.fid);
            l=fgetl(o.fid); o.line_number=o.line_number+1;
        catch
            o.abort('reading full line as string');
        end
    end

    function  frewindl(o)
        % Rewind the file to the previous line (the line needs to have been read with the overriden fgetl() function above
        try
            fseek(o.fid,o.pos_previous_line,'bof');
            o.line_number=o.line_number-1;
        catch
            o.abort('rewinding one line up');
        end
    end

    function varargout = fgetl_formatted(o,sFormat)
        % Reads the first string within a line
        try
            l=o.fgetl(); A = textscan(l,sFormat,1);
            if isempty(A{1}); error('empty');     end;
            varargout=[A{:}];
        catch
            o.abort(['reading line with format: ' sFormat]);
        end
    end

    function [s] = fgetl_1s(o)
        % Reads the first string within a line
        try
            l=o.fgetl(); A = textscan(l,'%s %*s',1);
            s=A{1}{1};
        catch
            o.abort('reading full line as string');
        end
    end

    function [S] = fgetl_strings(o)
        % Reads the first string within a line
        try
            l=o.fgetl(); A = textscan(l,'%s');
            S=A{1};
        catch
            o.abort('reading strings from line');
        end
    end

    function varargout = fgetl_floats(o,n,bDontAbort)
        % Reads the first n floats on a line. The rest of the line is disarded (and lost..).
        % - n may be omitted in which case n is determined using the number of output arguments
        % - If n is -1, then as many successive floats as possible are read on the line
        % - bDontAbort: if set to true, abort is not called and the file is not closed on error

        % Default variables
        if ~exist('n','var');          n=nargout;        end;
        if ~exist('bDontAbort','var'); bDontAbort=false; end;
        % Reading line as string 
        l  =o.fgetl();
        try
            if n==-1
                format = '%f ';
                A = textscan(l,format);
                n=length(A);
            else
                format = [repmat('%f ',1,n) '%*s'];
                A = textscan(l,format,1);
                % Checks
                if any(cellfun(@isempty,A)); error('wrong size'); end;
            end
            if length(A)~=n;             error('wrong size'); end;
            if isempty(A{1});            error('empty');     end;
            % Returning 
            if nargout==1 && n>1
                varargout{1}=[A{:}];
            else
                varargout=A;
            end
        catch me
            if bDontAbort
                % going back to previous position in file
                o.frewindl();
                % rethrowing error
                rethrow(me)
            else
                o.abort(sprintf('reading %d float(s)',n));
            end
        end
    end

    function varargout = fgetl_ints(o,n)
        % Reads the first n integers on a line. The rest of the line is disarded (and lost..).
        % - n may be omitted in which case n is determined using the number of output arguments
        % - If n is -1, then as many successive ints as possible are read on the line
        % Default variable
        if ~exist('n','var'); n=nargout; end;
        % Reading line as string
        l=o.fgetl(); 
        try
            if n==-1
                format = '%d ';
                A = textscan(l,format);
                n=length(A);
            else
                format = [repmat('%d ',1,n) '%*s'];
                A = textscan(l,format,1);
                % Checks
                if any(cellfun(@isempty,A)); error('wrong size'); end;
            end
            if length(A)~=n;             error('wrong size'); end;
            if isempty(A{1});            error('empty');     end;
            % Returning 
            if nargout==1 && n>1
                varargout{1}=[A{:}];
            else
                varargout=A;
            end
        catch 
            o.abort(sprintf('reading %d int(s)',n));
        end
    end

    % --------------------------------------------------------------------------------
    % ---  Misc Helper functions for text files
    % --------------------------------------------------------------------------------
    function raw_lines = fgetlines(o,n)
        % Read n lines and returns them in a cell array. If n is omitted, the reading is done until EOF.
        if ~exist('n','var')
            raw_lines=textscan(o.fid, '%s',   'delimiter', '\n','whitespace',''); raw_lines=raw_lines{1};
            n=length(raw_lines);
        else
            raw_lines=textscan(o.fid, '%s', n,'delimiter', '\n','whitespace',''); raw_lines=raw_lines{1};
        end
        o.line_number=o.line_number+n;
    end

    % --------------------------------------------------------------------------------
    % ---  
    % --------------------------------------------------------------------------------
    function varargout = fgetfloats(o,nCol,nLines)
        % Default variables
        if ~exist('nCol','var');   nCol=[];   end;
        if ~exist('nLines','var'); nLines=[]; end;

        % Reading floats
        format = [repmat('%f ',1,nCol) '%*s'];
        A = textscan(o.fid,format);
        % TODO TODO
%             % Checks
%             if any(cellfun(@isempty,A)); error('wrong size'); end;
%             if length(A)~=n;             error('wrong size'); end;
%             if isempty(A{1});            error('empty');     end;
%             % Returning 
%             if nargout==1 && n>1
%                 varargout{1}=[A{:}];
%             else
%                 varargout=A;
%             end
        varargout{1}=[A{:}];
    end


end % methods hidden

end % class
