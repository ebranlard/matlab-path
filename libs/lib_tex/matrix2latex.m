function matrix2latex(matrix, filename ,varargin)
% Adapted from matlab central
% Adaptor: E. Branlard
% Added: - different formats
%        - possibility to write to terminal
%        - give info about script, date and folder as a latex comment
%
% Usage:
% matrix2late(matrix, filename, varargs)
% where
%   - matrix is a 2 dimensional numerical or cell array
%   - filename is a valid filename, in which the resulting latex code will
%   be stored
%   - varargs is one ore more of the following (denominator, value) combinations
%      + 'rowLabels', array -> Can be used to label the rows of the
%      resulting latex table
%      + 'columnLabels', array -> Can be used to label the columns of the
%      resulting latex table
%      + 'alignment', 'value' -> Can be used to specify the alginment of
%      the table within the latex document. Valid arguments are: 'l', 'c',
%      and 'r' for left, center, and right, respectively
%      + 'format', 'value' -> Can be used to format the input data. 'value'
%      has to be a valid format string, similar to the ones used in
%      fprintf('format', value);
%      + 'size', 'value' -> One of latex' recognized font-sizes, e.g. tiny,
%      HUGE, Large, large, LARGE, etc.
%
% Example input:
%   matrix = [1.5 1.764; 3.523 0.2];
%   rowLabels = {'row 1', 'row 2'};
%   columnLabels = {'col 1', 'col 2'};
%   matrix2latex(matrix, 'out.tex', 'rowLabels', rowLabels, 'columnLabels', columnLabels, 'alignment', 'c', 'format', '%-6.2f', 'size', 'tiny');
%
% The resulting latex file can be included into any latex document by:
% /input{out.tex}
%
% Put Filename to 0 if you don't want a file but a print in the terminal:
%


% --------------------------------------------------------------------------------
% --- Examples 
% --------------------------------------------------------------------------------
if nargin==0
    M=eye(3,4);

    ColLabels={'Col1','Col2 $x$','Col3 $y$','Col4 $z$'};
    RowLabels={'Row1','Row2','Row3'};
    matrix2latex(M,0,'columnlabels', ColLabels );
    matrix2latex(M,0,'rowlabels',RowLabels );
    matrix2latex(M,0,'columnlabels', ColLabels, 'rowlabels',RowLabels );

    matrix2latex(M,0,'columnlabels', ColLabels ,'format','%.3f');

    matrix2latex(M,0,'columnlabels', ColLabels ,'format',{'%.3f','%d','%02d'},'alignment',{'c','l'});

    return

end


%% Default values
rowLabels = [];
colLabels = [];
alignment = 'l';
format = [];
textsize = [];
format='%.1f';
hline='';

%% Checking if outputing to file
if (rem(nargin,2) == 1 || nargin < 2)
    fileoutput=0;
elseif(filename==0)
    fileoutput=0;
elseif(isequal(filename,''))
    fileoutput=0;
end


%% Checking user's arguments
okargs = {'rowlabels','columnlabels', 'alignment', 'format', 'size','hline'};
for j=1:2:(nargin-2)
    pname = varargin{j};
    pval = varargin{j+1};
    k = strmatch(lower(pname), okargs);
    if isempty(k)
        error('matrix2latex: ', 'Unknown parameter name: %s.', pname);
    elseif length(k)>1
        error('matrix2latex: ', 'Ambiguous parameter name: %s.', pname);
    else
        switch(k)
            case 1  % rowlabels
                rowLabels = pval;
                if isnumeric(rowLabels)
                    rowLabels = cellstr(num2str(rowLabels(:)));
                end
            case 2  % column labels
                colLabels = pval;
                if isnumeric(colLabels)
                    colLabels = cellstr(num2str(colLabels(:)));
                end
            case 3  % alignment
                %                 alignment = lower(pval);
                %                 if alignment == 'right'
                %                     alignment = 'r';
                %                 end
                %                 if alignment == 'left'
                %                     alignment = 'l';
                %                 end
                %                 if alignment == 'center'
                %                     alignment = 'c';
                %                 end
                %                 if alignment ~= 'l' && alignment ~= 'c' && alignment ~= 'r'
                %                     alignment = 'l';
                %                     warning('matrix2latex: ', 'Unkown alignment. (Set it to \''left\''.)');
                %                 end
                alignment=pval;
            case 4  % format
                format = pval;
            case 5  % format
                textsize = pval;
            case 6  % hline
                hline = '\hline'
        end
    end
end
width = size(matrix, 2);
height = size(matrix, 1);

%% Using cells instead of single values
if(~isempty(format))
    if(~iscell(format))
        tmp=format;
        format={};
        format{1}=tmp;
    end
end
if(~isempty(alignment))
    if(~iscell(alignment))
        tmp=alignment;
        alignment={};
        alignment{1}=tmp;
    end
end


%% Formating matrix text and store it in a cell
if isnumeric(matrix)
    matrix = num2cell(matrix);
    for h=1:height
        for w=1:width
            if(~isempty(format))
                matrix{h, w} = num2str(matrix{h, w}, lower(format{ mod(w-1,length(format))+1  }));
            else
                matrix{h, w} = num2str(matrix{h, w});
            end
        end
    end
end

%% Switch between file or standard output
if(fileoutput)
    fid = fopen(filename, 'w');
else
    fid=1;
    disp('-------------------------------------------------------')
    disp(' ')
end


% --------------------------------------------------------------------------------
% --- Writting latex code 
% --------------------------------------------------------------------------------
global SCRIPT
try
    disp('% ----------------------------------- TABLE --------------------------------------')
    fprintf('%% Table generated by script: %s, from folder: %s, %s\n',SCRIPT.name,SCRIPT.run_dir,SCRIPT.run_date);
catch
    %
end
%     disp('\begin{tabcol}{}{}')
%% Text Size
if(~isempty(textsize))
    fprintf(fid,'\\begin{%s}', textsize);
end
%%  Tabular line
sindent='';
sbuff=sprintf('\\begin{tabular}{|');
if(~isempty(rowLabels))
    sbuff=strcat(sbuff,sprintf('l|'));
end
for i=1:width
    %sbuff=strcat(sbuff,sprintf('%c|', alignment));
    sbuff=strcat(sbuff,sprintf('%c|', lower(alignment{ mod(i-1,length(alignment))+1  })));
end
sbuff=strcat(sbuff,sprintf('}\r\n'));
fprintf(fid,'%s%s\n',sindent,sbuff);

%%  Header line
sindent='  ';
sbuff='';
fprintf(fid,'%s',hline);
if(~isempty(colLabels))
    if(~isempty(rowLabels))
        sbuff=strcat(sbuff,sprintf(' & '));
    end
    for w=1:width-1
        %sbuff=strcat(sbuff,sprintf('\\textbf{%s} & ', colLabels{w}));
        sbuff=strcat(sbuff,sprintf('%s & ', colLabels{w}));
    end
    %sbuff=strcat(sbuff,sprintf( '\\textbf{%s}\\\\\r\n', colLabels{width}));
    sbuff=strcat(sbuff,sprintf( '%s\\\\\r\n', colLabels{width}));
    fprintf(fid,'%s%s\n',sindent,sbuff);
    fprintf(fid,'%s\\hline\n',sindent);
end

%%  Loop over matrix lines
sindent='  ';
sbuff='';
for h=1:height
    if(~isempty(rowLabels))
        %sbuff=strcat(sbuff,sprintf('\\textbf{%s} & ', rowLabels{h}));
        sbuff=strcat(sbuff,sprintf('%s & ', rowLabels{h}));
    end
    for w=1:width-1
        sbuff=strcat(sbuff,sprintf(' %s & ', matrix{h, w}));
    end
    sbuff=strcat(sbuff,sprintf(' %s\\\\ \n %s', matrix{h, width},hline));
    fprintf(fid,'%s%s\n',sindent,sbuff);
    sbuff='     ';
end

%%  Closing latex commands
fprintf(fid,'\\end{tabular}');
if(~isempty(textsize))
    fprintf(fid,'\\end{%s}', textsize);
end
%     disp('\end{tabcol}');

%% Closing file
if fid~=1
    fclose(fid);
    fprintf('Written to file: %s\n',filename)
else
    disp(' ')
    disp('% --------------------------------------------------------------------------------')
    disp(' ')
end


