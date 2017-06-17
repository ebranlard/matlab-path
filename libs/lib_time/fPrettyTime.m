function s=fPrettyTime(t)
    % fPrettyTime: returns a 6-characters string corresponding to the input time in seconds.
    %   fPrettyTime(612)=='10m12s'
    % AUTHOR: E. Branlard

    if(t<0)
        s='------';
    elseif (t<1) 
        c=floor(t*100);
        s=sprintf('%2.2d.%2.2ds',0,c);
    elseif(t<60) 
        s=floor(t);
        c=floor((t-s)*100);
        s=sprintf('%2.2d.%2.2ds',s,c);
    elseif(t<3600) 
        m=floor(t/60);
        s=mod( floor(t), 60);
        s=sprintf('%2.2dm%2.2ds',m,s);
    elseif(t<86400) 
        h=floor(t/3600);
        m=floor(( mod( floor(t) , 3600))/60);
        s=sprintf('%2.2dh%2.2dm',h,m);
    elseif(t<8553600) 
        d=floor(t/86400);
        h=floor( mod(floor(t), 86400)/3600);
        s=sprintf('%2.2dd%2.2dh',d,h);
    else
        s='+3mon.';
    end

