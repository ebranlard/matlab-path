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

%%
global PATH; % can turn out to be usefull

%% Figure Init
InitPlot


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


