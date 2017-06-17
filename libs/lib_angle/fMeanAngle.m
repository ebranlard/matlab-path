function u = fMeanAngle(phi)
    if any(phi>180)
        warning('Most likely you intend to call fMeanAngled not fMeanAngle').
    end
    % Returns the average of the anple phi, in radians
	u = mod(angle(nanmean(exp(1i*phi))),2*pi);
end
