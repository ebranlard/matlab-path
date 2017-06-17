function [X_mean, Y_mean, Z_mean, Z_std, X_c, Y_c] = fBinStats2D(x, y, z, xBinEdges,yBinEdges)
% Return statistics of z in each 2d-bin of x,y

%  INPUT
%    x,y,z  : vector of values
%    xBinEdges : vectors of edges for values of x
%    yBinEdges : vectors of edges for values of x
% 
%  OUTPUT
%    x_mean: matrix(nBinsX,nBinsY) of mean value of x in each bin, most likely close to the center value x_c, but not necessarly
%    y_mean: matrix(nBinsX,nBinsY) of mean value of y in each bin, most likely close to the center value y_c, but not necessarly
%    z_mean: matrix(nBinsX,nBinsY) of mean value of y in each bin
%    z_std : matrix(nBinsX,nBinsY) of std  value of y in each bin
%    x_c   : bin center along x
%    y_c   : bin center along y



%%  Init of output variables
nBinsX = length(xBinEdges)-1 ;
nBinsY = length(yBinEdges)-1 ;
X_mean = nan(nBinsX,nBinsY);
Y_mean = nan(nBinsX,nBinsY);
Z_mean = nan(nBinsX,nBinsY);
Z_std  = nan(nBinsX,nBinsY);

% Center values
x_c = xBinEdges(1:end-1) + diff(xBinEdges)/2;
y_c = yBinEdges(1:end-1) + diff(yBinEdges)/2;

[Y_c,X_c]=meshgrid(y_c,x_c);

%% Conditioning on x first
[~,IX] = histc(x,xBinEdges);


% Computing statistics in each bin
for i = 1:length(xBinEdges)-1
    % Indexes, within x, corresponding to values in bin x
    IBinX   = find(IX== i);

    % 
    [~,IY] = histc(y(IBinX),yBinEdges);
    
    for j = 1:length(yBinEdges)-1
        % Indexes, within x, corresponding to values in bin x and y
        IBinXY = IBinX(IY==j);
        X_mean(i,j) = nanmean(x(IBinXY)) ;
        Y_mean(i,j) = nanmean(y(IBinXY)) ;
        Z_mean(i,j) = nanmean(z(IBinXY)) ;
        Z_std (i,j) = nanstd (y(IBinXY)) ;
    end
end
 
