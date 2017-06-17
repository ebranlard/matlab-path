function y=fRemoveAroundNaNGaps(x)
    % This function expands the intervals of NaN values by 1 position at the start and end of a NaN interval 
    % In other words it inserts a NaN value each time the values of x goes from a normal value to NaN or from NaN to a normal value
    % See the unit tests for examples
    % Author: E. Branlard

%% Unit tests
if nargin==0
    isequaln(fRemoveAroundNaNGaps([1]),[1])
    isequaln(fRemoveAroundNaNGaps([NaN]),[NaN])
    isequaln(fRemoveAroundNaNGaps([1 NaN]),[NaN NaN])
    isequaln(fRemoveAroundNaNGaps([NaN 2]),[NaN NaN])
    isequaln(fRemoveAroundNaNGaps([NaN NaN]),[NaN NaN])
    isequaln(fRemoveAroundNaNGaps([1 2 3 4 5]),[1 2 3 4 5])
    isequaln(fRemoveAroundNaNGaps([NaN 2 3 4 5]),[NaN NaN 3 4 5])
    isequaln(fRemoveAroundNaNGaps([1 2 3 4 NaN]),[1 2 3 NaN NaN])
    isequaln(fRemoveAroundNaNGaps([1 2 3 NaN 5 6 7]),[1 2 NaN NaN NaN 6 7])
    isequaln(fRemoveAroundNaNGaps([1 2 NaN NaN 5 6 7]),[1 NaN NaN NaN NaN 6 7])
    isequaln(fRemoveAroundNaNGaps([NaN 2 3 4 NaN NaN 7 8]),[NaN NaN 3 NaN NaN NaN NaN 8])
    isequaln(fRemoveAroundNaNGaps([NaN NaN 3 4 NaN 6 7 NaN]),[NaN NaN NaN NaN NaN NaN NaN NaN])
else

%%  Core of the function
y=x(:)';

bNan=isnan(x);
dbNan=diff(bNan);

% If the diff of NaN is 1, then we are just before a NaN range. So we eliminate this positiion
y(dbNan==1) = NaN; % Note dbNan is shorter than x, but the last value of dInan cannot be 1

% We handle the case where the last position is NaN
if bNan(end) && length(x)>1
    y(end-1)=NaN;
end
% We handle the case where the first position is NaN
if bNan(1) && length(x)>1
    y(2)=NaN;
end

% [[dbNan NaN] ; x ; bNan; y];
% If the diff of NaN is -1, then we are just after a NaN range. So we eliminate this positiion
% We remove the last position from dBNan and we shift everything by one position
if size(x,1)==1
    dbNan=[0 dbNan(1:end-1)];
else
    dbNan=[0;dbNan(1:end-1)];
end
y(dbNan==-1) = NaN; 



end
    
