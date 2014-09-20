function [ln,allgood,wrds]=fReadTillKeyword(fid,kwd)
  MAX_READ=1000000;
  i=0;
  while i<MAX_READ
    i=i+1;
    % reading lines and extracting words
    ln=fgetl(fid);
    %fprintf('ln={%s}\n',ln);
    if ~isempty(ln)
      wrds=textscan(ln,'%s','ReturnOnError',true);
      if ~isempty(wrds{1})
        if isequal(lower(wrds{1}{1}),lower(kwd))
            wrds=wrds{1};
          break
        end
      end
    end
  end
  allgood=(i~=MAX_READ); % return true if did not reach max value

