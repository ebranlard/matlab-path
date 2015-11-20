%% Cleaning
clc;
clearPath;
clc;
clear all;close all
warning on;
% 
%% Getting Script info
global SCRIPT;
stk=dbstack(); % stk(1) is InitClear, stk(2) is the caller
if(length(stk)>1) 
    nline=stk(2).line;
    file=stk(2).file;
    [~,SCRIPT.name]=fileparts(file);
    clear('nline','file')
else
    % default value
    SCRIPT.name='Unknown'; 
end
% directory
SCRIPT.run_dir=pwd(); % windows? try cd otherwise
% date
SCRIPT.run_date=date();
clear('stk')

%% Default global vars
setenv('EDITOR','gvim --remote-tab-silent')





global PATH; % can turn out to be usefull
setFigureTitle(0);
setMatFigure(1);
% setFigurePath({'D:/Work/reports/figs/','D:/Work/reports/figsdump/'})
% setMatFigurePath({'D:/Work/reports/matfig/','./matfig/'})
% setFigureFont('default');
setFigureWidth('14');
setFigureHeight('10.5');
setFigureFont('13');
setFigurePath({'/work/publications/phdthesis/figsdump/','./figs/'})
setMatFigurePath({'/work/publications/phdthesis/matfig/', './matfig/'})

set(0,'DefaultLineLineWidth',1.3)
%  
% set(0,'DefaultAxesFontName','courier')
%  set(0,'DefaultAxesFontName','cms serif')
 
%  set(0,'DefaultAxeslinewidth',1)
%  set(0,'DefaultPatchlinewidth',1)
set(0,'DefaultAxesColorOrder',fColrs());
% Default figure position
A=get( 0, 'ScreenSize' );
if(A(3)>1920)
    set(0, 'DefaultFigurePosition',[  2467 432   560   420]) % two screen
else
  set(0, 'DefaultFigurePosition',[  692   354   560   420]) % One screen
end
clear('A');
%% Find report folder location
%global FigurePath
%Find report location
%FigurePath=FindFigsMain();
%setFigurePath(FigurePath);
%disp(FigurePath)
%
%
% 
%% Set default user Paths
if(exist('setDefaultPath','file'))
    setDefaultPath;
end


