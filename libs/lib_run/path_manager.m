function [] = path_manager(action,action_paths,h)
    % path_manager: handles matlabpath without polutting it. 
    %    It uses a global variables for now to store the paths added to the path
    % varargout=cell;
    PATH_SEP='|:|'; % string used to separate path within

    % --------------------------------------------------------------------------------
    % ---  Default values
    % --------------------------------------------------------------------------------
    % Future work: handle to PATH variable
    if ~exist('h','var')
        h=0;
    end
    %
    global PATH;
    if ~isfield(PATH,'STRING')
        PATH.STRING='';
    end
    %

    % --------------------------------------------------------------------------------
    % ---
    % --------------------------------------------------------------------------------
    if ~exist('action','var')
        path_manager('list')
        return
    end

    switch action
        case {'clean','clear'}
            path_manager('rm',PATH.STRING);
            return
        case 'rm'
            paths_active = paths2cell(PATH.STRING)      ;
            paths        = paths2cell(action_paths);

            % Removing from matlabpath
            for ip=1:length(paths)
                if ~isempty(paths{ip})
                    fprintf('path_manager: -%s\n',paths{ip});
                    rmpath(paths{ip})
                end
            end
            % Removing from global path list
            paths=setdiff(paths_active,paths);
            % Reforming the global PATH string
            PATH.STRING=strjoin(paths,PATH_SEP);
        case 'add'
            paths_active = paths2cell(PATH.STRING) ;
            paths        = paths2cell(action_paths);
            paths_added  = paths2cell(action_paths);
            
            % Adding to matlabpath
            for ip=1:length(paths)
                if ~isempty(paths{ip})
                    if  isempty(intersect(paths_active,paths))
                        if ~exist(paths{ip},'dir')
                            warning('path_manager: path does not exists: %s',paths{ip});
                        else
                            addpath(paths{ip});
                            paths_active{end+1} = paths{ip};
                            fprintf('path_manager: +%s\n',paths{ip});
                        end
                    else
                        fprintf('path_manager: =%s already in path\n',paths{ip})
                    end
                end
            end
            PATH.STRING=strjoin(paths_active,PATH_SEP);

        case 'list'
            paths = paths2cell(PATH.STRING)      ;
            for ip=1:length(paths)
                if ~isempty(paths{ip})
                    fprintf('path_manager:  %s\n',paths{ip})
                end
            end

        otherwise
            error('unknwon action')
    end






    % --------------------------------------------------------------------------------
    % --- Local functions 
    % --------------------------------------------------------------------------------
    function paths=paths2cell(paths)
        PATH_SEP='|:|'; % string used to separate path within
        % Splitting paths into a cell of strings
        if ischar(paths)
            paths=strsplit(paths,PATH_SEP);
        elseif iscell(paths)
            paths=paths;
        end
    end

end
