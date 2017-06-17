function M2=fRemoveAroundGaps(M,dtThreashold,nExtent)
% This function sets nExtent NaN in the data if a jump of timestamp is above a certain threashold dtThreashold
% M: matrix(n,m) where the first column is the time stamp
% Author: E. Branlard

%%  Core of the function
dt     = diff(M(:,1))   ;
bJumps = dt>dtThreashold;
IJumps = find(bJumps)   ;

% We add indexes to Ijumps to form IExtended
IExtended=IJumps;
for i=1:nExtent
    IExtended = [IExtended IJumps+i IJumps-i];
end
% We remove duplicate index values and make sure they are not too small or big;
IExtended = unique(IExtended);
IExtended = IExtended(IExtended>0);
IExtended = IExtended(IExtended<length(dt));

% We Nan the index
M2=M;
M2(IExtended,2:end)=NaN;

