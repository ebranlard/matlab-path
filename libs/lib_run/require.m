function []=require(libname_or_folder,Version)
% add a specific path to matlab path in a safe way.
% Two versions of a same library cannot be imported twice.
% The path is cleared by clearPath() which is usually called by InitClear
%
% For now, libname should be a field of the variable PATH.
% see setDefaultPath to define such field

global PATH;

%% Safety checks for old libraries
if(isequal(libname_or_folder,'VC_LIB_MAT')) 
    warning('Library VC_LIB_MAT is depreciated, use Chipmunk instead')
end


%% Checks
if ~exist('Version','var'); Version=''; end
if ~isfield(PATH,'STRING'); PATH.STRING=''; end

%

if  isdir(libname_or_folder) && isempty(Version)
    % --------------------------------------------------------------------------------
    % --- The user requested a given folder
    % --------------------------------------------------------------------------------
    folder=libname_or_folder;
    path_manager('add',folder);
else
    % --------------------------------------------------------------------------------
    % --- Loading a library / version
    % --------------------------------------------------------------------------------
    libname=libname_or_folder;


    % --- Handling if the field/libname is not present in variable PATH
    if ~isfield(PATH,libname) 
        isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
        if isOctave
            bUI=false;
        else
            % Test whether we have ui available
            if usejava('jvm') && ~feature('ShowFigureWindows')
                bUI=false;
            else
                bUI=true;
            end
        end

        % config_file (needs to be in harmony with setDefaultPath)
        lib_require_folder = fileparts(mfilename('fullpath'))                 ;
        config_file        = fullfile(lib_require_folder,'require_config.dat');

        % Getting Library directory from user
        msg=sprintf(['The location of the library %s was not defined on this machine.\n' ...
                     'The directory for this library needs to be specified in the following file:\n' ...
                     '    %s \n' ...
                     'using the format:   \n' ...
                     '    %s = ''directory/''   \n\n' ...
                     'Do you want to specify the directory now? [y/n]' ...  
                      ],libname,config_file,libname);
        if bUI
            button = questdlg(msg, 'Library not found','Yes (GUI)', 'No', 'Yes (no gui)','Yes (GUI)');
            if strcmpi(button, 'No');
                disp(msg);
                disp('Aborting')
                return; 
            end
            if strcmpi(button, 'Yes (GUI)');
                folder = uigetdir;
            else
                folder = input('Enter directory here: ','s');
            end
        else
            disp(msg);
            m=input('','s');
            m=lower(m(1));
            disp(m)
            if m(1)=='n' 
                disp('Aborting')
                return; 
            end
            folder = input('Enter directory here: ','s');
        end
        folder=fullfile([folder filesep]);
        % Appending to config file 
        fid = fopen(config_file, 'a+');
        fprintf(fid, '%s = ''%s''\n', libname,folder);
        fclose(fid);
        % Adding field to PATH
        eval(sprintf('PATH.%s=''%s'';',libname,folder));
    end


    % --- 
    folder=getfield(PATH,libname);
    if(~isdir(folder))
        % config_file (needs to be in harmony with setDefaultPath)
        lib_require_folder = fileparts(mfilename('fullpath'))                 ;
        config_file        = fullfile(lib_require_folder,'require_config.dat');

        error('Unable to load libray %s, the folder does not exist: %s\n',libname,folder);
    end
    %


    % ---  Getting proper version of library
    if isequal(Version,'latest')
        fold_content=dir(folder);
        % we load the latest version
        vnum   = nan(1,length(fold_content));
        IValid = false(1,length(fold_content));
        FoldNames = cell(1,length(fold_content));
        for iFold =1:length(fold_content)
            FoldNames{iFold} = fold_content(iFold).name;
            if fold_content(iFold).name(1)=='v'
                IValid(iFold)=true;
                vnum(iFold) =str2num(fold_content(iFold).name(2:3));
            else
                IValid(iFold)=false;
            end
        end
        vnum     = vnum(IValid);
        FoldNames = FoldNames(IValid);
        if isempty(vnum)
            error('Not folder starting with `v` found in %s',folder)
        end
        [s I]=sort(vnum);
        %         keyboard
        Version=FoldNames{I(end)};
    end


    if exist('OCTAVE_VERSION', 'builtin') ~= 0;
        PATH.STRING = strrep(PATH.STRING,'\','/');
        folder      = strrep(folder     ,'\','/');
    end
    [startIndex, ~, ~, matchStr] = regexp(PATH.STRING, [folder '[a-zA-Z0-9_-]*']);
    if(length(startIndex)>1)
        error('this should not happen, it means the same library has been loaded twice');
    else
        if(length(startIndex)==1)
            % Just printing warning of reload
            [~, ~, ~, ~, ~, ~, g]=regexp(matchStr{1},'/');
            oldVersion=g{end};
            if(~isequal(oldVersion,Version))
                fprintf('require:     %s was already loaded with version %s and is now replaced by version %s\n',libname,oldVersion,Version);
                oldfolder=[folder oldVersion];
                path_manager('rm',oldfolder);
            else
                fprintf('require:     %s was already loaded with version %s\n',libname,oldVersion);
            end
        end
        folder=[folder Version];
        % now let's do the real loading...
        if(~isdir(folder))
            % config_file (needs to be in harmony with setDefaultPath)
            lib_require_folder = fileparts(mfilename('fullpath'))                 ;
            config_file        = fullfile(lib_require_folder,'require_config.dat');

            error(sprintf('Unable to load libray %s version %s from %s\nPlease edit the path manually in the config file:\n\nedit %s',libname,Version,folder,config_file));
        else
            path_manager('add',folder);
        end
    end
end
