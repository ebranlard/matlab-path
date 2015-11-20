function clearPath
global PATH;



% Removing paths found in PATH.STRING from matlab path
if(isfield(PATH,'STRING') && ~isempty(PATH.STRING))
    path_manager('clean');
end
% Removing paths found in PATH.STRING_TMP from matlab path
% if(isfield(PATH,'STRING_TMP') && ~isempty(PATH.STRING_TMP))
%     paths=strsplit(PATH.STRING_TMP,PATH_SEP);
%     for ip=1:length(paths)
%         if ~isempty(paths(ip))
%             rmpath(paths(ip))
%         end
%     end
%     rmpath(PATH.STRING_TMP)
%     PATH.STRING='';
%     PATH=rmfield(PATH,'STRING_TMP');
% end



% a further security, but not general
s=path;
[startIndex, ~, ~, matchStr] = regexp(s, '/work/');
if(~isempty(startIndex))
    fprintf('clearPath:\t path was not properly cleaned\n');
    nToberemoved=length(startIndex);
    nRemoved=0;
    i=1;
    %we split the path
    [~, ~, ~, ~, ~, ~, g] = regexp(s, ':');
    while nRemoved<nToberemoved
        [a, ~, ~, ~, ~, ~, ~] = regexp(g(i), '/work/');
        if(~isempty(a))
            rmpath(g{i});
            nRemoved=nRemoved+1;
        end
        i=i+1;
    end
end
