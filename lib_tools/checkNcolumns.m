function M=checkNcolumns(M,nCol,varname,scriptname)
% Chekcs that the input has a given amount of columns, if there is no ambiguity and if its' not the case, transpose it

%% Argument checks
% minimum two arguments
error(nargchk(2,4,nargin))
switch nargin
	case 2
      varname='VAR';
      scriptname='SCRIPT';
	case 3
      scriptname='SCRIPT';
end


%%
[n1,n2]=size(M);
if(n1==n2 && n1==nCol)
  fprintf('!Warning: Calling %s: Possible ambiguity in the dimension of %s. Make sure you input has a fixed number of columns equal to %d.\n',scriptname,varname,nCol);
elseif (n1==nCol)
  fprintf('!Warning: Calling %s: Variable %s should have a fixed number of columns %d. Transposing it..\n',scriptname,varname,nCol);
  M=transpose(M);
end
