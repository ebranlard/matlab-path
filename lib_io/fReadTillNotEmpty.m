function [ln,allgood,wrds]=fReadTillNotEmpty(fid)
    MAX_READ=1000000;
    i=0;
    bNOEOF=true;
    while i<MAX_READ
        if ~feof(fid)
            i=i+1;
            % reading lines and extracting words
            ln=fgetl(fid);
            %fprintf('ln={%s}\n',ln);
            if ~isempty(ln)
                wrds=textscan(ln,'%s','ReturnOnError',true);
                if ~isempty(wrds{1})
                    wrds=wrds{1};
                    break
                end
            end
        else
            wrds={};
            ln='';
            bNOEOF=false;
            break
        end
    end
    allgood=(i~=MAX_READ)&&bNOEOF; % return true if did not reach max value

