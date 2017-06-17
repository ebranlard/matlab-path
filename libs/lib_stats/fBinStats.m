function [x_mean, y_mean, y_std, x_c, IBins] = fBinStats(x, y, xBinEdges)
% Return statistics of y in each bin values of x
%  INPUT
%    x,y  : vector of values
%    xBinEdges : vectors of edges for values of x
% 
%  OUTPUT
%    x_mean: mean value of x in each bin, most likely close to the center value x_c, but not necessarly
%    y_mean: mean value of y in each bin
%    y_std : std  value of y in each bin
%    x_c   : bin center
%    IBins : cell containing indexes for each Bin

[~,I] = histc(x,xBinEdges);

nBins=length(xBinEdges)-1;
x_mean=nan(1,nBins);
y_mean=nan(1,nBins);
y_std =nan(1,nBins);
x_c   =nan(1,nBins);
IBins =cell(1,nBins);

% Computing statistics in each bin
for i = 1:nBins
    IBins{i} = find(I==i);
    x_mean = nanmean(x(IBins{i})) ;
    y_mean = nanmean(y(IBins{i})) ;
    y_std  = nanstd (y(IBins{i})) ;
end

% Center values
x_c(1:end) = xBinEdges(1:end-1) + diff(xBinEdges)/2;
