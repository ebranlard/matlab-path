function fPrettyPrintTable(sData,ColNames,nMax)
    % sData: cell of string values
    % ColNames: column names

    %
    nCols  = length(ColNames);
    nLines = size(sData,1)   ;

    % --- We determine the max length and number of unique values
    nUnique   = zeros(1,nCols);
    MaxLength = zeros(1,nCols);
    FirstColWidth=max(6,ceil(log(nLines)/log(10)));
    for i=1:nCols
        MaxLength(i)=length(ColNames{i})+2;
    end
    for iLine=1:nLines
        for i=1:nCols
            MaxLength(i)=max(MaxLength(i),length(sData{iLine,i}));
        end
    end
    for i=1:nCols
        nUnique(i)=length(unique(sData(:,i)));
    end

    % --- Now we print everything to screen
    sFormatFirstColInt  =['%' num2str(FirstColWidth) 'd|'];
    sFormatFirstColStr  =['%' num2str(FirstColWidth) 's|'];
%     sLineDelimiterFirst =strcat(repmat('_',1,FirstColWidth),'|');
    sFormatStr='|';
    sFormatInt='|';
    sLineDelimiter='|';
    for i=1:nCols
        sFormatStr     = strcat(sFormatStr,['%' num2str(MaxLength(i)) 's|']);
        sFormatInt     = strcat(sFormatInt,['%' num2str(MaxLength(i)) 'd|']);
        sLineDelimiter = strcat(sLineDelimiter,repmat('_',1,MaxLength(i)),'|');
%         if (i==length(IDet) || i==length(I))
        if i==nCols
            % Adding an extra bar to markthe beginning
            sFormatStr     = strcat(sFormatStr,'|');
            sFormatInt     = strcat(sFormatInt,'|');
            sLineDelimiter = strcat(sLineDelimiter,'|');
        end
    end
    % Adding First column to delimiter (begining and end)
%     sLineDelimiter=strcat(sLineDelimiterFirst,sLineDelimiter,sLineDelimiterFirst);
    sHeader1=sprintf([sFormatFirstColStr sFormatStr sFormatFirstColStr],'Ln:',ColNames{:},'Ln:');
    sHeader2=sprintf([sFormatFirstColStr sFormatInt],' ',nUnique);
    nHalf=-1;
    if nMax>1 && nMax<nLines;
        nHalf=floor(nMax/2);
        IRecord=[1:nHalf (nLines-nHalf):nLines] ;
    else
        IRecord=1:nLines;
    end;
    fprintf('%s\n',sHeader2)
    fprintf('%s\n',sHeader1)
    %         fprintf('%s\n',sLineDelimiter)
    for iLine=IRecord
        sLine=sprintf(sFormatStr,sData{iLine,:});
        fprintf([sFormatFirstColInt '%s' sFormatFirstColInt '\n'],iLine,sLine,iLine);
        if nHalf>1 
            if iLine==nHalf
                disp('  ... ')
            end
            if iLine==nHalf
                fprintf('%s\n',sHeader1)
                %                     fprintf('%s\n',sLineDelimiter)
            end
        else
            if mod(iLine,100)==0
                fprintf('%s\n',sHeader1)
                %                     fprintf('%s\n',sLineDelimiter)
            end
        end
    end
    %         fprintf('%s\n',sLineDelimiter)
    fprintf('%s\n',sHeader1)
    fprintf('%s\n',sHeader2)
    %%
end
