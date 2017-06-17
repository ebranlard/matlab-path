function [nGaps, Gaps, IGaps] = fGetGapsInfo(sig,bPlot)
    % Returns time gap info in signals
    % sig: a signal matrix, where the first column is time and the others are signals
    % bPlot, optional: plots
    % 
    % Author: E. Branlard


    %% 
    sampling = (sig(2,1)-sig(1,1)); % delta_t
    tol      = sampling/20        ; % 

    %%
    delta = diff(sig(:,1))              ;
    IGaps = find( abs(delta-delta(1))>tol );
    nGaps = length(IGaps);

    Gaps=[];
    for ig=1:length(IGaps)
        Gaps{ig}.ts_start = sig(IGaps(ig)  ,1)         ;
        Gaps{ig}.ts_end   = sig(IGaps(ig)+1,1)         ;
        Gaps{ig}.t_start  = datestr(Gaps{ig}.ts_start);
        Gaps{ig}.t_end    = datestr(Gaps{ig}.ts_end)  ;
        Gaps{ig}.duration = etime(datevec(Gaps{ig}.ts_end), datevec(Gaps{ig}.ts_start));
    end
    %

    if exist('bPlot','var')
        if bPlot
            %
            YMIN=min(sig(:,2));
            YMAX=max(sig(:,2));
            %
            figure, hold all
            %sig(isnan(sig(:,2)),2)=0;
            for ig=1:length(IGaps)
                %     plot([sig(IGaps(ig),1), sig(IGaps(ig)+1,1)], [0, 15], 'r');
                rectangle('Position',[sig(IGaps(ig),1), YMIN, sig(IGaps(ig)+1,1)-sig(IGaps(ig),1),YMAX],'FaceColor','r')
            end
            plot(sig(:,1),sig(:,2))
            %plot(sigf(:,1),sigf(:,2))
            %sum(sum(sigf-sigf2,'omitnan'))
        end
    end
