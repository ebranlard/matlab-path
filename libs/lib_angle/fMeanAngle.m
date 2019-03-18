function u = fMeanAngle(phi)
    %% Test
    if nargin==0
        vphi=[0 pi/2 pi 2*pi];
        fMeanAngle(vphi)
        xm=mean(cos(vphi));
        ym=mean(sin(vphi));
        t=atan2(ym,xm)

        return
    end


    if any(phi>180)
        warning('Most likely you intend to call fMeanAngled not fMeanAngle')
    end
    % Returns the average of the anple phi, in radians
	u = mod(angle(mean(exp(1i*phi))),2*pi);
end
