function [a, b, R2, R2fit, y2] = fLinearRegression(x,y,bOffset,fig_handle)
bGood=~isnan(x) & ~isnan(y);
x=x(bGood);
y=y(bGood);
vx=linspace(min([min(x),min(y)]),max([max(x),max(y)]),100);
% 

if ~exist('fig_handle','var'); fig_handle = []  ; end
if ~exist('bOffset'   ,'var'); bOffset    = true; end


if bOffset
    % Linear regression with offset: y = ax + b

    % --- Method1
    %X = [ones(length(x),1) x];
    %p = X\y;
    %a=p(2);
    %b=p(1);
    %y2=X*p;
    % --- Method2
    p = polyfit(x,y,1);
    a=p(1);
    b=p(2);
    y2=a*x+b;
    y3=a*vx+b;
else
    % Linear regression without offset: y = ax
   a = x\y;
   b = 0  ;
   y2= a*x;
   y3= a*vx;
end

R2    = fRsquare(x,y) ; % R2    = 1 - sum((x - y).^2)/sum((x - mean(x)).^2) ;
R2fit = fRsquare(y,y2); % R2fit = 1 - sum((y - y2).^2)/sum((y - mean(y)).^2);


% 
if ~isempty(fig_handle)
    figure(fig_handle)
    hold all
    plot(x,y,'.')
    plot(vx,y3,'-')
    plot(vx,vx,'k')
end
