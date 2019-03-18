%%
global PLOT

% --- EXPORT LIB (need lib_export)
try
    setFigureTitle(0);
    setMatFigure(1);
    % setFigurePath({'D:/Work/reports/figs/','D:/Work/reports/figsdump/'})
    % setMatFigurePath({'D:/Work/reports/matfig/','./matfig/'})
    % setFigureFont('default');
    setFigureWidth('14');
    setFigureHeight('10.5');
    setFigureFont('13');
    setFigurePath({'./figs/'})
    setMatFigurePath({'./matfig/'})
catch
    %
end

% --- PLOT LIB (need lib_plot)
try
    PLOT.fDispatchFigs=@dispatchFigs;
    PLOT.fColrs=@fColrs;
    set(0,'DefaultAxesColorOrder',fColrs());
catch
    %
end

% --- DEFAULT PLOT OPTIONS
set(0,'DefaultLineLineWidth',1.3)
% set(0,'DefaultAxesFontName','courier')
%  set(0,'DefaultAxesFontName','cms serif')
%  set(0,'DefaultAxeslinewidth',1)
%  set(0,'DefaultPatchlinewidth',1)
% Default figure position
A=get( 0, 'ScreenSize' );
if(A(3)>1920)
    set(0, 'DefaultFigurePosition',[  2467 432   560   420]) % two screen
else
  set(0, 'DefaultFigurePosition',[  692   354   560   420]) % One screen
end
clear('A');

