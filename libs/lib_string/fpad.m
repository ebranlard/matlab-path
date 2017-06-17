function s=fpad(s,len,side,padCharacter)
    % Quick and dirty implementation of matlab pad funciton available in Matlab2017

    if iscell(s)
        %len=max(cellfun(@(ss)length(ss),s))
        for i=1:len(s)
            s{i}=fpad(s,len,side,padCharacter);
        end
    else
      if length(s)>len
          s=s(1:len);
      else
          s2=repmat(padCharacter,1,len-length(s));
          if isequal(side,'right')
              s=[s s2];
          else
              s=[s2 s];
          end
      end
    end
end
