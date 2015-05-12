function clearPath
global PATH
if(isfield(PATH,'STRING') && ~isempty(PATH.STRING))
    rmpath(PATH.STRING)
    PATH.STRING='';
    PATH=rmfield(PATH,'STRING');
end
if(isfield(PATH,'STRING_TMP') && ~isempty(PATH.STRING_TMP))
    rmpath(PATH.STRING_TMP)
    PATH.STRING='';
    PATH=rmfield(PATH,'STRING_TMP');
end
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
