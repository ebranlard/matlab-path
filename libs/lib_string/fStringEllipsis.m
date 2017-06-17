function sOut=fStringEllipsis(s,nMax)
    % fStringEllipsis: shorten a strings if longer than nMax
    %
    % Author: E. Branlard

    % --- Constant
    ELLIPSIS_CHARS='...';

    % --- Test functions
    if nargin ==0
        disp(repmat('-',1,16));
        disp(fStringEllipsis('C:\short\butlong\path.m',16))
        disp(repmat('-',1,15));
        disp(fStringEllipsis('short',15))
        disp(fStringEllipsis('_a_short_butlong_path__',15))
        disp(fStringEllipsis('C:\short\butlong\path.m',15))
        disp(repmat('-',1,15));
        disp(fStringEllipsis('\shortbutlongpath.m',15))
        disp(fStringEllipsis('s\hortbutlongpath.m',15))
        disp(fStringEllipsis('sho\rtbutlongpath.m',15))
        disp(fStringEllipsis('shortbut\longpath.m',15))
        disp(fStringEllipsis('shortbutlongpath\.m',15))
        disp(fStringEllipsis('shortbutlongpath.m\',15))
        disp(repmat('-',1,5));
        disp(fStringEllipsis('C:\short\butlong\path.m',5))
        disp(repmat('-',1,3));
        disp(fStringEllipsis('C:\short\butlong\path.m',3))
        disp(repmat('-',1,2));
        disp(fStringEllipsis('C:\short\butlong\path.m',2))
        disp(repmat('-',1,1));
        disp(fStringEllipsis('C:\short\butlong\path.m',1))
        return
    end

    nEll=length(ELLIPSIS_CHARS);
    if length(s)>nMax
        % --- If its a path, we try our best to accomodate
        [comps,I]=regexp(s,'\\|/','split');
        if ~isempty(I)
            % If first comp is a drive letter, we merge it with the second, this gives more balance to the output
            if length(comps{1})==2 && comps{1}(2)==':'
                comps{2}=[comps{1} s(I(1)) comps{2}];
                comps = comps(2:end);
                I     = I(2:end)    ;
            end
            % 
            iStart=1;
            iEnd  =length(comps);
            sHead='';
            sTail='';
            % Tail is favored since we start with the tail
            while length(sHead)+length(sTail)<nMax
                sTail=strcat(s(I(iEnd-1)),comps{iEnd},sTail);
                if length(sHead)+length(sTail)>=nMax
                    break
                end
                iEnd=iEnd-1;
                if iEnd==iStart
                    sHead=strcat(sHead,comps{iStart});
                    break
                end
                sHead=strcat(sHead,comps{iStart},s(I(iStart)));
                iStart=iStart+1;
            end
            n=length(sHead)+length(sTail);
            nRemove=n-nMax;
            % Tail is favored again since we remove it first
            % TODO: share the burden
            if length(sHead)>(nRemove+nEll)
                sOut=[sHead(1:(end-nRemove-nEll)) ELLIPSIS_CHARS sTail];
            else
                sOut=[sHead ELLIPSIS_CHARS sTail((nRemove+nEll+1):end)];
            end
        else
            % --- Standard procedure
            nKeep=floor((nMax-length(ELLIPSIS_CHARS))/2);
            sOut=strcat(s(1:nKeep),ELLIPSIS_CHARS);
            nRemain=nMax-length(sOut);
            sOut=strcat(sOut, s((end-nRemain+1):end));
        end
        sOut=sOut(1:nMax); % Safety is ELLIPSIS_CHARS>nMax
    else
        sOut=s;
    end


end
