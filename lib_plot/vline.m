function vline(vx,varargin)
% Adds vertical lines to a plot at locations vx (vector or scalar)
%
% Example : figure,plot(1:2),hold on, vline(1.5, 'Color' ,'k','LineStyle','--')
%
% E. Branlard - February 2014
%
for x=vx
    line([x x],get(gca(),'YLim'),varargin{:})
end
