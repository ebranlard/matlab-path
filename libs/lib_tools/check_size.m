function M=check_size(M,S,varname)
% Chekcs that the input has a given size

%% Argument checks
error(nargchk(2,3,nargin))
switch nargin
	case 2
      varname='VAR';
end
%%
if(S~=size(M))
    err(sprintf('Variable %s does not have the proper size. Found %d, required %d',varname,size(M)));
end
