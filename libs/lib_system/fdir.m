function FileNames=fdir(pattern)
%     f0=java.io.File(pattern);
%     FileNames=f0.listFiles();
% Using eval of dir the command is executed way faster, but a single string is returned
s         = evalc(sprintf('dir(''%s'')',pattern));
FileNames = strsplit(s)                          ;
bKeep     = cellfun(@(x)~isempty(x),FileNames)   ;
FileNames = FileNames(bKeep);
end

