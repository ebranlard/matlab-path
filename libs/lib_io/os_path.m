classdef os_path < handle;
%% Documentation
% Matlab implementation of python os.path package


% --------------------------------------------------------------------------------}
%% --- Static Hidden 
% --------------------------------------------------------------------------------{
methods(Static=true,Hidden=true);
    function [good_slash,bad_slash,good_slash_escaped]=get_slashes()
        if ispc()
            good_slash='\';
            bad_slash='/';
            good_slash_escaped='\\';
        else
            good_slash='/';
            bad_slash='\';
            good_slash_escaped='/';
        end
    end
end

% --------------------------------------------------------------------------------}
%% --- Static 
% --------------------------------------------------------------------------------{
methods(Static=true);

    % --------------------------------------------------------------------------------}
    %% --- abspath
    % --------------------------------------------------------------------------------{
    function d=abspath(p)
        % Return a normalized absolutized version of the pathname path. On most platforms, this is equivalent to calling the function normpath() as follows: normpath(join(os.getcwd(), path))
        d=os_path.normpath( os_path.join( pwd(), p ) );
    end

    % --------------------------------------------------------------------------------}
    %% --- basename
    % --------------------------------------------------------------------------------{
    function BaseName=basename(p)
        % Return the base name of pathname path. This is the second element of the pair returned by passing path to the function split(). Note that the result of this function is different from the Unix basename program; where basename for '/foo/bar/' returns 'bar', the basename() function returns an empty string ('').
        [~,f,e]=fileparts(p);
        BaseName=[f e];
    end


    % --------------------------------------------------------------------------------}
    %% --- commonprefix 
    % --------------------------------------------------------------------------------{
    function prefix=commonprefix(p1,p2)
        % Return the longest path prefix (taken character-by-character) that is a prefix of all paths in list. If list is empty, return the empty string (''). Note that this may return invalid paths because it works a character at a time.
        prefix='';

        % swaping p1 and and p2 so that p1 is always the shortest
        if length(p1)>length(p2)
            pt=p2; p2=p1; p1=pt;
        end
        % Returning if empty
        if isempty(p1); return; end
        % Looping on chars while strings match
        i=1;
        while i<=length(p1) && isequal(p1(1:i),p2(1:i))
            i=i+1;
        end
        prefix=p1(1:(i-1));
    end

    % --------------------------------------------------------------------------------}
    %% --- exists 
    % --------------------------------------------------------------------------------{
    function b=exists(p)
        % Return True if path refers to an existing path. Returns False for broken symbolic links. On some platforms, this function may return False if permission is not granted to execute os.stat() on the requested file, even if the path physically exists.
        b=exist(p,'file');
    end


    % --------------------------------------------------------------------------------}
    %% --- dirname
    % --------------------------------------------------------------------------------{
    function d=dirname(p)
        % Return the directory name of pathname path. This is the first element of the pair returned by passing path to the function split().
        [d]=fileparts(p);
    end


    % --------------------------------------------------------------------------------}
    %% --- isabs
    % --------------------------------------------------------------------------------{
    function b=isabs(p)
        % Return True if path is an absolute pathname. On Unix, that means it begins with a slash, on Windows that it begins with a (back)slash after chopping off a potential drive letter.
        b=false;
        if ispc()
            if length(p)>=1
                b= p(1)=='/' || p(1)=='\';
            end
            if length(p)>=3
                b= b || ( (p(2)==':') && ischar(p(1))  && (p(3)=='/' || p(3)=='\') ); 
            end
        else
            good_slash=os_path.get_slashes();
            b=p(1)==good_slash;
        end
    end

    % --------------------------------------------------------------------------------}
    %% --- isfile 
    % --------------------------------------------------------------------------------{
    function b=isfile(p)
        % Return True if path is an existing regular file. This follows symbolic links, so both islink() and isfile() can be true for the same path.
        b=exist(p, 'file') == 2 ; 
    end

    % --------------------------------------------------------------------------------}
    %% --- isdir 
    % --------------------------------------------------------------------------------{
    function b=isdir(p)
        % Return True if path is an existing directory. This follows symbolic links, so both islink() and isdir() can be true for the same path.
        b=exist(p, 'file') == 7 ; 
    end

    % --------------------------------------------------------------------------------}
    %% --- join 
    % --------------------------------------------------------------------------------{
    function p=join(p1,p2,varargin)
        % Join one or more path components intelligently. The return value is the concatenation of path and any members of *paths with exactly one directory separator (os.sep) following each non-empty part except the last, meaning that the result will only end in a separator if the last part is empty. If a component is an absolute path, all previous components are thrown away and joining continues from the absolute path component.
        % 
        % On Windows, the drive letter is not reset when an absolute path component (e.g., r'\foo') is encountered. If a component contains a drive letter, all previous components are thrown away and the drive letter is reset. Note that since there is a current directory for each drive, os.path.join("c:", "foo") represents a path relative to the current directory on drive C: (c:foo), not c:\foo.

        [good_slash]=os_path.get_slashes();
        % normalizing
        %p1 = os_path.normpath(p1);
        %p2 = os_path.normpath(p2);
        % See which ones are absolute paths
        if isempty(p1)
            p=p2; % all previous components are thrown away
        elseif os_path.isabs(p2) 
            if ispc() && (p2(1)=='\' || p2(1)=='/')
               if os_path.isabs(p1) 
                   if ischar(p1) 
                        p=[p1(1:2) p2]; % Keeping drive letter
                    else
                        p=p2;
                    end
                else
                    p=[p1 p2];
                end
            else
                p=p2; % all previous components are thrown away
            end
        else
            % --- Joining p1 and p2
            % TODO: ensure only one slash
            p=[p1 good_slash p2];
            %p=os_path.normpath(p);
        end

        % --- Recursive call
        if ~isempty(varargin)>0
            p=join(p,varargin{:});
        end
    end
    
    % --------------------------------------------------------------------------------}
    %% --- normcase 
    % --------------------------------------------------------------------------------{
    function p=normcase(p)
        % Normalize the case of a pathname. On Unix and Mac OS X, this returns the path unchanged; on case-insensitive filesystems, it converts the path to lowercase. On Windows, it also converts forward slashes to backward slashes.
        if ispc()
            p=lowercase(p);
        end
    end

    % --------------------------------------------------------------------------------}
    %% --- normpath 
    % --------------------------------------------------------------------------------{
    function p=normpath(p)
        % Normalize a pathname by collapsing redundant separators and up-level references so that A//B, A/B/, A/./B and A/foo/../B all become A/B. This string manipulation may change the meaning of a path that contains symbolic links. On Windows, it converts forward slashes to backward slashes. To normalize case, use normcase().
        if isempty(p)
            p='';
            return;
        end
        % Changing slashes 
        [good_slash,bad_slash,good_slash_escaped]=os_path.get_slashes();
        p=strrep(p,bad_slash,good_slash);
        % Removing ".\" if file starts with that - And return
        if any(ismember(1,strfind(p,['.' good_slash])))
            p=os_path.normpath(p(3:end));
            return;
        end
        % Keeping "..\" if file starts with that - And return
        if any(ismember(1,regexp(p,['[\.][\.]+' good_slash_escaped])))
            I=strfind(p,good_slash);
            p=[p(1:I(1)) os_path.normpath(p((I(1)+1):end))];
            return;
        end
        % Removing dot within slashes
        pattern=[good_slash '.' good_slash];
        p=strrep(p,pattern,good_slash);
        % Removing duplicate slashes
        pattern=[good_slash_escaped '*'];
        p=regexprep(p,pattern,good_slash_escaped);

        % --- Handling "../"
        bContinue=true;
        while bContinue
           I=strfind(p,[good_slash '..' good_slash]);
           if isempty(I)
               bContinue=false;
           else
               if I(1)==1
                   p=p(4:end);
               else
                   p1   = p(1:(I(1)-1));
                   p2   = p(I(1)+4:end);
                   head = os_path.split(p1);
                   p    = os_path.join(head,p2);
               end
           end
        end

    end


    % --------------------------------------------------------------------------------}
    %% --- relpath 
    % --------------------------------------------------------------------------------{
    function rp=relpath(path, pstart)
        % Return a relative filepath to path either from the current directory or from an optional start directory. This is a path computation: the filesystem is not accessed to confirm the existence or nature of path or start.
        % start defaults to os.curdir.
        if ~exist('pstart','var'); pstart=pwd(); end;
        disp('TODO');
        rp=[path pstart]; 
    end


    % --------------------------------------------------------------------------------}
    %% --- split 
    % --------------------------------------------------------------------------------{
    function [head,tail]=split(p)
        % Split the pathname path into a pair, (head, tail) where tail is the last pathname component and head is everything leading up to that. The tail part will never contain a slash; if path ends in a slash, tail will be empty. If there is no slash in path, head will be empty. If path is empty, both head and tail are empty. Trailing slashes are stripped from head unless it is the root (one or more slashes only). In all cases, join(head, tail) returns a path to the same location as path (but the strings may differ). Also see the functions dirname() and basename().
        [d,b,e]=fileparts(p);
        head=d;
        tail=[b,e];
    end



end % methods static

end % class
