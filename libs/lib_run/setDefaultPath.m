function setDefaultPath()
    % Stores all the library directories stored in the config file into the global variables PATH
    % The config file is in the smae directory as the current script.
    % The file content is of the form where # is a comment
    %     libname = 'directory/'


    global PATH;

    % config_file (needs to be in harmony with require)
    lib_require_folder = fileparts(mfilename('fullpath'))                 ;
    config_file        = fullfile(lib_require_folder,'require_config.dat');

    % Opening config file
    lib_require_folder = fileparts(mfilename('fullpath'))                 ;
    fid=fopen(config_file,'r');
    %     try
    % Reading pairs of values libname=libfolder
    pairs = textscan(fid, '%s %s', 'Delimiter', '=', 'EmptyValue', 0, 'CommentStyle', '#');
    libnames   = pairs{1};
    libfolders = pairs{2};
    for i=1:length(libnames)
        libname  =libnames{i};
        libfolder=libfolders{i};
        libfolder=strrep(libfolder,'''','');
        libfolder=strrep(libfolder,';','');
        libfolder=strrep(libfolder,' ','');
        libname  =strrep(libname  ,' ','');
        libfolder=fullfile([libfolder filesep]);
        cmd=sprintf('PATH.%s=''%s'';;\n',libname,libfolder);
        % Storing the PATH.libname=folder
%         disp(cmd)
        eval(cmd);
    end
    %     catch
    %         rethrow
    %         fclose(fid);
    %     end
