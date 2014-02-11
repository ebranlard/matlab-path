function export(format,constrained)
% MyExportLib
% Emmanuel Branlard - December 2009
% Revisions:
% -June 2011: Exporting matlab fig file
% -April 2013: Standard latex, using subfigure package, added comments helping to generating script location

%% Default Parameters
% Paths
global FigurePath
if(isempty(FigurePath))
    FigurePath={'./'};
end
if(~iscell(FigurePath))
    FigurePath={FigurePath};
end
global MatFigurePath
if(isempty(MatFigurePath))
    MatFigurePath={'./matfig/'};
end
if(~iscell(MatFigurePath))
    MatFigurePath={MatFigurePath};
end

% Latex
global bFigureLatex
if(isempty(bFigureLatex))
    bFigureLatex=0;
end

% Figure Tight
global bFigureTight
if(isempty(bFigureTight))
    bFigureTight=1;
end
% Figure Font
global FigureFont
if(isempty(FigureFont))
    FigureFont='default';
end
% Figure RePosition: %should we resize the figure to the standard size : 560 420 or use the size from the user. By Default I reposition now
global bFigureRePosition
if(isempty(bFigureRePosition))
    bFigureRePosition=1;
end

% DoNothing
global bFigureDoNothing
if(isempty(bFigureDoNothing))
    bFigureDoNothing=0;  % default is actually doing something
end




% Check
if(bFigureLatex && bFigureTight)
    warning('Forcing loose figure to go with latex');
    bFigureTight=0;
end

if(bFigureDoNothing && bFigureRePosition)
    warning('Forcing Figure RePosition to 0 since you don''t want to do anything');
    bFigureRePosition=0;
end




% Figure size
global FigureWidth
global FigureHeight
if(isempty(FigureWidth) || isequal(FigureWidth,'0') )
    if(bFigureLatex)
        FigureWidth='14';
        FigureHeight='9.58';
    else
        FigureWidth='14';
    end
end
if(isempty(FigureHeight) || isequal(FigureHeight,'0'))
    FigureHeight='auto';
end




% Boolean flags
global bFigureTitle
if(isempty(bFigureTitle))
    bFigureTitle=1;
end
global bMatFigure
if(isempty(bMatFigure))
    bMatFigure=1;
end



if nargin < 2
    format =  'png';
    constrained =  0;
end

%% Defining style : this style is good for reports, should be adapted for presentations
% This helped : hgexport('FactoryStyle'), edit hgexport
MyStyle={};
% FORMAT PARAMETERS
MyStyle.Format= format;  %png or eps
MyStyle.Version= '1';
% SIZE PARAMETERS
if(bFigureTight)
    MyStyle.Bounds= 'tight'; % IMPORTANT : tight or loose
else
    MyStyle.Bounds= 'loose'; % IMPORTANT : tight or loose, for constrained plot use loose and texplot as well...
end
 MyStyle.Width= FigureWidth;
 MyStyle.Height= FigureHeight;
 MyStyle.Units= 'centimeters';
% RENDERING PARAMETERS
MyStyle.Color='rgb';  %bw, rgb, gray,cmyk
MyStyle.PSLevel= '2';
MyStyle.Renderer= 'auto'; %zbuffer , opengl
MyStyle.Resolution= 300;
MyStyle.LockAxes= 'on';  %fixes axis limit while exporting
MyStyle.ShowUI= 'off';   %show UI controls while exporting
% FONT PARAMETERS , defaul is scaled and min 11 
if isequal(FigureFont,'default') 
    MyStyle.FontMode= 'scaled'; %used to be fixed | scaled | none |auto
    MyStyle.FontSizeMin= '11'; %used to be 11
    MyStyle.ScaledFontSize= 'auto';
    MyStyle.FixedFontSize= '11'; % works only if font mode is fixed
else
    MyStyle.FontMode= 'fixed'; %used to be fixed | scaled | none |auto
    MyStyle.FontSizeMin= '11'; %used to be 11
    MyStyle.ScaledFontSize= 'auto';
    MyStyle.FixedFontSize= FigureFont; % only if font mode is fixed
end
MyStyle.FontName= 'auto';
% MyStyle.FontWeight= 'normal';  %'light', 'normal', 'demi', 'bold'
MyStyle.FontAngle= 'auto';   %'normal', 'italic', 'oblique'
MyStyle.FontEncoding= 'latin1';  %'latin1', 'adobe'
MyStyle.SeparateText= 'off';
% LINE PARAMETERS
MyStyle.LineMode= 'scaled';  % fixed | scaled | none |auto
MyStyle.LineWidthMin= '0.1';
%MyStyle.FixedLineWidth= '1.2';
%MyStyle.ScaledLineWidth= '1.5';
% MyStyle.Preview= 'none';
MyStyle.Background= 'w';

MyStyle.LineStyleMap= 'none'; %bw to let matlab do it
% MyStyle.ApplyStyle= '0';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creating fig path, for .fig if they don't exist
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(bMatFigure)
    for ifp=1:length(MatFigurePath)
        if(~isdir(MatFigurePath{ifp}))
            mkdir(MatFigurePath{ifp});
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Retrieving information about figure generation workspace
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Getting script file name
global SCRIPT

if isfield(SCRIPT,'name')
    % see InitClear
else
    SCRIPT.name='Unknown';
%     SCRIPT.run_date=today();
    SCRIPT.run_date='';
    SCRIPT.run_dir=pwd();
end

%% Looping on figures
%~ disp('Starting exportation...')
%~ disp(' ');
%~ disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp(' ');
figs=get(0,'children');
for i=1:length(figs)
    hfig=figs(length(figs)-i+1);  % fig handle
    % giving focus to the figure
    figure(hfig)
    %storing the title
    currentTitle=get(get(gca,'title'),'string') ;
    currentTitleLatexSafe=regexprep(currentTitle,'[%^_]','');
    % figure name from title or figure number
    if(isequal(currentTitle,'')||isequal(currentTitle,'   '))
        figName=sprintf('%d',hfig);
    else
        figName=title2filename(currentTitle);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Exporting the .fig
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if(bMatFigure)
        for(ifp=1:length(MatFigurePath))
            filename=sprintf('%s%s.fig',MatFigurePath{ifp},figName);
            saveas(hfig,filename);
        end
    end
    
    
    % remove figure title if needed
    if(~bFigureTitle)%
        set(gca,'Title',text('String','   '));
    end
    
    %axh=get(hfig,'CurrentAxes');
    %set(axh,'GridLineStyle','-.')%,'LineWidth',0.9)
    


    if(bFigureLatex)                
        format_ticks(gca,0.02,0.009,'FontSize',11); % font size useless, hgexport takes care of it
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Repositionning if needed 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if(bFigureRePosition)
        Position = get(hfig,'Position');
        if(Position(3)~=560 || Position(4)~=420)
            warning('I have to reposition the figure, setFigureRePosition to 0 if you don''t want this')
            set(hfig,'Position',[Position(1) Position(2) 560 420]);
            refresh(hfig); %redraw it
            disp(' ');
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Applying the style
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if(constrained)
        warning('Forcing loose figure to go with constrained figure');
        MyStyle.Bounds= 'loose'; % IMPORTANT : tight or loose
    end

    set(gcf,'color','w'); % white background in case we do nothing
    if ~bFigureDoNothing
        hgexport(hfig,tempname,MyStyle,'applystyle', true);
    end
    
    %     box on
    if(bFigureLatex)
        set(get(gca,'XLabel'),'Interpreter','Latex','FontSize',13);
        set(get(gca,'YLabel'),'Interpreter','Latex','FontSize',13);
        
        hlegend = findall(gcf,'tag','legend');
        legloc=get(hlegend,'Location');
        set(hlegend,'Interpreter','Latex','FontSize',11);
%         set(hlegend,'Location',legloc)    ;
%         pause(0.1);  % matlab needs to rest a little
%         legpos=get(hlegend,'OuterPosition');
%         set(hlegend,'OuterPosition',legpos);
    end
    
    if(constrained)
      % Actually just using the loose figure is enough to keep what the user has inputted it seems
        xlims=get(gca,'XLim');
        ylims=get(gca,'YLim');
        pause(1)
%         axis('equal');
%         axis square
        set(gca,'XLim',xlims);
        set(gca,'YLim',ylims);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Exporting in Figure Path
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for ifp=1:length(FigurePath)
        filename=sprintf('%s%s.%s',FigurePath{ifp},figName,MyStyle.Format);
%         fprintf('Path %s\n',FigurePath{ifp});
        if(isequal(format,'pdf'))           
            % Complex command for pdf
%             keyboard
             export_fig(hfig,filename)
        elseif(isequal(format,'tkz'))
            title('')
            if(constrained)
                ratio=1
            else
                if(isequal(FigureHeight,'auto'))
                    ratio=9.58/14;
                    ratio=10.108/14;
                    FigureHeight='10.108';
                else
                    ratio=str2num(FigureHeight)/str2num(FigureWidth);
                end
                if(isequal(FigureHeight,'9.58'))
                    FigureHeight='10.108'
                end
            end
            if(bFigureLatex)
                matlab2tikz(filename,'width','\fwidth','height',sprintf('%.3f\\fwidth',ratio),'parseStrings',false);
            else
                matlab2tikz(filename,'width','\fwidth','height',sprintf('%.3f\\fwidth',ratio));
            end
%             matlab2tikz(filename,'width',[FigureWidth 'cm'],'height',[FigureHeight 'cm']);
            %,'width',FigureWidth,'height',FigureHeight
        else
           % Command for eps or png
            hgexport(gcf,filename,MyStyle);
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Restoring title
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    title(currentTitle);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % generating latex code
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if(mod(length(figs),2)==0)
        if(mod(i,2)==0)
%             fprintf('in \\autoref{fig:%s}\n',figNameLast);
%             fprintf('\\biimages{%s}{%s}{%s}{0.49}{0.49}{}\n',figNameLast,figName,currentTitle);
            
            fprintf('in \\autoref{fig:%sMain}\n',figNameLast);
            disp('% ---------------------------------- FIGURES -------------------------------------')
            fprintf('%% Figure generated by script: %s, from folder: %s, %s\n',SCRIPT.name,SCRIPT.run_dir,SCRIPT.run_date);
            fprintf('%% subfig a:  in \\autoref{fig:%s}\n',figNameLast);
            fprintf('%% subfig b:  in \\autoref{fig:%s}\n',figName);
            fprintf('\\noindent\\begin{figure}[!htbp]\\centering%%\n');
            fprintf('  \\begin{subfigure}[b]{0.49\\textwidth}\\centering \\includegraphics[width=\\textwidth]{%s}\\caption{}\\label{fig:%s}\\end{subfigure}%%\n',figNameLast,figNameLast);
            fprintf('  \\begin{subfigure}[b]{0.49\\textwidth}\\centering \\includegraphics[width=\\textwidth]{%s}\\caption{}\\label{fig:%s}\\end{subfigure}%%\n',figName,figName);
            fprintf('  \\caption{%s}\\label{fig:%sMain}%%\n',currentTitleLatexSafe,figNameLast);
            fprintf('\\end{figure}\n');
            disp('% --------------------------------------------------------------------------------')
            disp(' ')
        end
        figNameLast=figName;
    else
        if(mod(i,2)==0)
%             fprintf('in \\autoref{fig:%s}\n',figNameLast);
%             fprintf('\\biimages{%s}{%s}{%s}{0.49}{0.49}{}\n',figNameLast,figName,currentTitle);
            fprintf('in \\autoref{fig:%sMain}\n',figNameLast);
            disp('% ---------------------------------- FIGURES -------------------------------------')
            fprintf('%% Figure generated by script: %s, from folder: %s, %s\n',SCRIPT.name,SCRIPT.run_dir,SCRIPT.run_date);
            fprintf('%% subfig a:  in \\autoref{fig:%s}\n',figNameLast);
            fprintf('%% subfig b:  in \\autoref{fig:%s}\n',figName);
            fprintf('\\noindent\\begin{figure}[!htbp]\\centering%%\n');
            fprintf('  \\begin{subfigure}[b]{0.49\\textwidth}\\centering \\includegraphics[width=\\textwidth]{%s}\\caption{}\\label{fig:%s}\\end{subfigure}%%\n',figNameLast,figNameLast);
            fprintf('  \\begin{subfigure}[b]{0.49\\textwidth}\\centering \\includegraphics[width=\\textwidth]{%s}\\caption{}\\label{fig:%s}\\end{subfigure}%%\n',figName,figName);
            fprintf('  \\caption{%s}\\label{fig:%sMain}%%\n',currentTitleLatexSafe,figNameLast);
            fprintf('\\end{figure}\n');
            disp('% --------------------------------------------------------------------------------')
            disp(' ')
        else
            if(i==length(figs))
%                 fprintf('in \\autoref{fig:%s}\n',figName);
%                 fprintf('\\imageb{%s}{%s}{0.5}{}\n',figName,currentTitle);
                fprintf('in \\autoref{fig:%s}\n',figName);
                disp('% ---------------------------------- FIGURE --------------------------------------')
                fprintf('%% Figure generated by script: %s, from folder: %s, %s\n',SCRIPT.name,SCRIPT.run_dir,SCRIPT.run_date);
                fprintf('\\noindent\\begin{figure}[!htbp]\\centering%%\n');
                fprintf('  \\includegraphics[width=0.49\\textwidth]{%s}\n',figName);
                fprintf('  \\caption{%s}\\label{fig:%s}%%\n',currentTitleLatexSafe,figName);
                fprintf('\\end{figure}\n');
                disp('% --------------------------------------------------------------------------------')
                disp(' ')
            end
        end
        figNameLast=figName;
    end
    
end
disp(' ');
%~ disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
%~ disp(' ');
%~ disp('Done.')
end
