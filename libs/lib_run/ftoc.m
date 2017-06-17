function [dt,s]=ftoc(varargin) 
    % ftoc: toc with more options. 
    % ftic records the "message" given as argument.
    % ftoc possibly display this message together with the elapsed time.
    %      The message/time can be returned if desired
    % ftic and ftoc rely on the global variable TICTOC
    %
    % AUTHOR: E. Branlard

    global TICTOC;

    % --- Init
    dt = 0 ;
    s  = '';

    % --- Checks
    if ~isfield(TICTOC,'Times')
        warning('ftoc called but ftic was not called before');
        return
    end
    if TICTOC.iHead<=0
        warning('ftoc called too many times, the calling stack of ftic is empty.');
        return
    end
    

    % Compuing delta t
    t_end=clock();
    dt= etime(t_end,TICTOC.Times{TICTOC.iHead});
    % Output string
    s=sprintf('[TIME] %s - %s',TICTOC.Names{TICTOC.iHead},fPrettyTime(dt));
    if nargout==0 % TODO, option for display to screen
        % Removing string written by ftic, if the option Erase is on
        if TICTOC.bErase(TICTOC.iHead)
            fprintf(repmat('\b',1,TICTOC.nChar+8));
        end
        % Showing string to screen
        disp(s);
    end
    TICTOC.Names{TICTOC.iHead}  = ''   ;
    TICTOC.Times{TICTOC.iHead}  = NaN  ;
    TICTOC.bErase(TICTOC.iHead) = false;
    % Reducing head
    TICTOC.iHead=TICTOC.iHead-1;
end

function s=fPrettyTime(t)
    % Sub function to display time using 6 characters
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
end

