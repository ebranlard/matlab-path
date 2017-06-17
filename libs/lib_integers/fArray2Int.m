function I=fArray2Int(v,bRespectOriginalOrder)
% Maps an array (e.g. of floats to an array of integer
% Identical values in the original array are mapped to identical integers.

% When the option bRespectOriginalOrder is true, then the first value of v will be assigned the integer value 1, even if this value is not the lowest value of the vector

% --- Default arguments
if ~exist('bRespectOriginalOrder','var'); bRespectOriginalOrder = false; end;

if bRespectOriginalOrder
    % trick here to respect input order..
    [~,ii] =unique(v);
    ii=sort(ii);
    vu=v(ii);
else
    % Unique returns sorted values
    vu =unique(v);
end

I=zeros(length(v),1);
% looping on sorted unique values
for i=1:length(vu)
    b= v==vu(i); % selecting values of v that corresponds to current unique value
    I(b)=i;
end
