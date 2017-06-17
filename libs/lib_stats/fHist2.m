function [histmat,xEdges,yEdges]  = fHist2(x, y, xEdges, yEdges)
% function histmat  = hist2(x, y, xEdges, yEdges)
%
% size(Histmat)=[length(y) length(x)]
%
% Extract 2D histogram data containing the number of events
% of [x , y] pairs that fall in each bin of the grid defined by 
% xEdges and yEdges. The Edges are vectors with monotonically 
% non-decreasing values.  
%
%
%EXAMPLE 
%
% events = 1000000;
% x1 = sqrt(0.05)*randn(events,1)-0.5; x2 = sqrt(0.05)*randn(events,1)+0.5;
% y1 = sqrt(0.05)*randn(events,1)+0.5; y2 = sqrt(0.05)*randn(events,1)-0.5;
% x= [x1;x2]; y = [y1;y2];
%
%For linearly spaced Edges:
% xEdges = linspace(-1,1,64); yEdges = linspace(-1,1,64);
% histmat = hist2(x, y, xEdges, yEdges);
% figure; pcolor(xEdges,yEdges,histmat'); colorbar ; axis square tight ;
%
%For nonlinearly spaced Edges:
% xEdges_ = logspace(0,log10(3),64)-2; yEdges_ = linspace(-1,1,64);
% histmat_ = hist2(x, y, xEdges_, yEdges_);
% figure; pcolor(xEdges_,yEdges_,histmat_'); colorbar ; axis square tight ;

% University of Debrecen, PET Center/Laszlo Balkay 2006
% email: balkay@pet.dote.hu
%% Default arguments
if ~exist('xEdges','var'); xEdges=linspace(min(x)-10*eps(min(x)),max(x)+10*eps(max(x)),min(length(x),40)); end
if ~exist('yEdges','var'); yEdges=linspace(min(y)-10*eps(min(y)),max(y)+10*eps(max(y)),min(length(y),41)); end

%% Safety checks
if nargin < 2
    error ('The two first input arguments are required!');
    return;
end
if any(size(x) ~= size(y)) 
    error ('The size of the two first input vectors should be same!');
    return;
end

if length(xEdges)<2    ; error  ('xEdges should be minimum of length 2.'); end
if length(yEdges)<2    ; error  ('yEdges should be minimum of length 2.'); end
if min(x)<xEdges(1)    ; warning('First x bin does not contain the minimum data value.'); end
if max(x)>=xEdges(end) ; warning('Last x bin does not contain the maximum data value.'); end
if min(y)<yEdges(1)    ; warning('First y bin does not contain the minimum data value.'); end
if max(y)>=yEdges(end) ; warning('Last y bin does not contain the mayimum data value.'); end


%% 
[xn, xbin] = histc(x,xEdges);
[yn, ybin] = histc(y,yEdges);

%xbin, ybin zero for out of range values 
% (see the help of histc) force this event to the 
% first bins
xbin(find(xbin == 0)) = inf;
ybin(find(ybin == 0)) = inf;

xnbin = length(xEdges);
ynbin = length(yEdges);

%% Providing a unique bin index number depending on the x or y bin number
% if xnbin >= ynbin
%     xy = ybin*(xnbin) + xbin;
%       indexshift =  xnbin; 
% else
    xy = xbin*(ynbin) + ybin;
      indexshift =  ynbin; 
% end

%[xyuni, m, n] = unique(xy);
xyuni = unique(xy);
if xyuni(end)==Inf
    xyuni(end) = []; 
end
hstres = histc(xy,xyuni);

% keyboard

clear xy;

histmat = zeros(ynbin,xnbin);
histmat(xyuni-indexshift) = hstres;
