function M_out = fResampleDir(M,t_ref,dt_ref,dt_old,method)
%  We resample such that the value at t is the mean of all the data within [t-dt/2 ; t+dt/2[
%
% Author: E. Branlard
%
% 
rad2deg=360/(2*pi);
% --- Converting direction to x-y components
DataX  = 90-M(:,2)            ; % Directions in x-y coordinate system (Y = North)
Dataxy = [M(:,1) cosd(DataX) sind(DataX)]; % Components in the x-y system
% --- Resampling
Mxy_out = fResample(Dataxy,t_ref,dt_ref,dt_old,method);
%---- Converting direction back to an angle
M_out      = zeros(size(Mxy_out,1),2);
M_out(:,1) = Mxy_out(:,1)            ; % time
M_out(:,2) = mod(90-atan2(Mxy_out(:,3),Mxy_out(:,2))*rad2deg,360); % Back to N direction
