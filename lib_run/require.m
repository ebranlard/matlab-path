function []=require(libname,varargin)
% add a specific path to matlab path in a safe way.
% Two versions of a same library cannot be imported twice.
% The path is cleared by clearPath() which is usually called by InitClear
%
% For now, libname should be a field of the variable PATH.
% see setDefaultPath to define such field

global PATH

%% Safety checks for old libraries
if(isequal(libname,'VC_LIB_MAT')) 
    warning('Library VC_LIB_MAT is depreciated, use Chipmunk instead')
end



%% Arguments checks
if(nargin>1)
    Version=varargin{1};
    if(nargin==3)
        bSilent=varargin{2}; 
    else
        bSilent=0;
    end
else
    Version='';
end

if(~isfield(PATH,'STRING'))
    PATH.STRING='';
end
if(~isfield(PATH,libname))
    warning(sprintf('%s is not in variable PATH',libname)); % TODO , accept stuff that are not in PATH
    folder=libname;
    if ~isfield(PATH,'STRING_TMP')
        PATH.STRING_TMP='';
    end
    PATH.STRING_TMP=[PATH.STRING_TMP ':' folder];
    addpath(folder);
else
    folder=getfield(PATH,libname);

    vers=dir([folder 'v*']);
    if isequal(Version,'latest')
        % we load the latest version
        vnum=zeros(1,length(vers));
        for iv =1:length(vers)
            vnum(iv) =str2num(vers(iv).name(2:3));
        end
        [s I]=sort(vnum);
        %         keyboard
        Version=vers(I(end)).name;
    end


    [startIndex, ~, ~, matchStr] = regexp(PATH.STRING, [folder '[a-zA-Z0-9_-]*']);
    if(length(startIndex)>1)
        error('this should not happen, it means the same library has been loaded twice');
    else
        if(length(startIndex)==1)
            % Just printing warning of reload
            [~, ~, ~, ~, ~, ~, g]=regexp(matchStr{1},'/');
            oldVersion=g{end};
            if(~bSilent)
                if(~isequal(oldVersion,Version))
                    fprintf('require:\t %s was already loaded with version %s and is now replaced by version %s\n',libname,oldVersion,Version);
                else
                    fprintf('require:\t %s was already loaded with version %s\n',libname,oldVersion);
                end
            end
            oldfolder=[folder oldVersion];
            % removing the path string
            [~, ~, ~, ~, ~, ~, g] = regexp(PATH.STRING, [oldfolder ':']);
            PATH.STRING=strcat(g{:});
            % and the path...
            rmpath(oldfolder);

        end
        folder=[folder Version];
        % now let's do the real loading...
        if(~isdir(folder))
            error(sprintf('Unable to load libray %s version %s',libname,Version));
        else
            addpath(folder);
            if(~bSilent)
                fprintf('require:\t addding path %s\n',folder);
            end
            setfield(PATH,libname,'LOADED');
            PATH.STRING=[PATH.STRING folder ':'];          
        end
    end
end
