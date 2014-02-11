function [ output_args ] = fDrawRotArrow(R,theta1,theta2,scale,col,linewidth,arrowlength,arrowangle  )
% close all
% figure,hold all
% plot(-1:1,-1:1)
dtheta=(theta2-theta1)/10;

vectarrowb([R*cosd(theta2-dtheta) R*sind(theta2-dtheta)],[R*cosd(theta2) R*sind(theta2)],scale,col,linewidth,arrowlength,arrowangle )

bUseSpline=false;
if bUseSpline
    X = [cosd(theta1) cosd(theta2)]*R;
    Y = [sind(theta1) sind(theta2)]*R;
    Xi= cosd(theta2/2+theta1/2)*R;
    Yi= sind(theta2/2+theta1/2)*R;
    Xa = [X(1) Xi X(2)];
    Ya = [Y(1) Yi Y(2)];
    t  = 1:numel(Xa);
    ts = linspace(min(t),max(t),numel(Xa)*5); % has to be a fine grid
    xx = spline(t,Xa,ts);
    yy = spline(t,Ya,ts);
else
    % we use a circle
    vtheta=linspace(theta1,theta2,30);
    xx = cosd(vtheta)*R;
    yy = sind(vtheta)*R;
end



plot(xx,yy,'Color',col,'LineWidth',linewidth);

% xlim([-1.5 1.5])
% ylim([-1.5 1.5])
% axis equal
end

