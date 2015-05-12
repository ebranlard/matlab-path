function vline(vx,varargin)
% Adds vertical lines to a plot at locations vx (vector or scalar)
%
% Example : figure,plot(1:2),hold on, vline(1.5, 'Color' ,'k','LineStyle','--')
%
% E. Branlard - February 2014
%
bLegend=true;
for x=vx
    if bLegend
        line([x x],get(gca(),'YLim'),varargin{:})
        bLegend=false;
    else
        line([x x],get(gca(),'YLim'),varargin{:},'handlevisibility','off')
    end
end
