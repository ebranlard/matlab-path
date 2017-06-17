function u = fMeanAngled(phi)
    % Returns the average of the anple phi, in degrees
	u = mod(angle(nanmean(exp(1i*pi*phi/180)))*180/pi,360);
end
