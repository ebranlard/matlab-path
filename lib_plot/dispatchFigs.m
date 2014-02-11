function []=dispatchFigs(varargin)
% Dispatch figures over the screen and not on top of each other
% E. Branlard June 2013
%
% dispatchFigs : no arguments: try his best to put the figure on the screen without resizing figures
% dispatchFigs(1) : use a defaults grid on the 2 or 1 screen
% dispatchFigs(3,4) : use grid 3x4 on screen 1 
% dispatchFigs(3,4,2) : use grid 3x4 on screen 2 
% dispatchFigs(3,4,2,2) : use grid 3x4 on screen 1 and 2x2 on screen two
%
% Parameters
hWin=60; %height of matlab toolbar + window manager
Laptop=[1600 900];
xMenuBar=110; 
yMenuBar=0;

A=get( 0, 'ScreenSize' );
if(A(3)>Laptop(1))
    S{1}=[xMenuBar A(4)-yMenuBar A(3)-Laptop(1) A(4)-yMenuBar];
    S{2}=[A(3)-Laptop(1) A(4) A(3) Laptop(2)];
else
    S{1}=[xMenuBar Laptop(2)-yMenuBar Laptop(1) Laptop(2)];
end

nScreens=length(S);

% try to dispatch without resizing figs)
if(nargin==0 || (nargin==1 && varargin{1}==0))
    iScreen=1;
    ScreenRoom=S{1};
    figs=get(0,'children');
    for i=1:length(figs)
        hfig=figs(length(figs)-i+1);  % fig handle
        hfig=figs(length(figs)-i+1);  % fig handle
        P=get(hfig,'Position');
        P(1)=ScreenRoom(1);
        P(2)=ScreenRoom(2)-P(4)-hWin;
        set(hfig,'Position',P);
        set(hfig,'Visible','on');
        ScreenRoom(1)= ScreenRoom(1)+P(3);
        if(ScreenRoom(1)+P(3)>ScreenRoom(3))
            ScreenRoom(1)=S{iScreen}(1);
            ScreenRoom(2)= ScreenRoom(2)-P(4)-hWin;
        end
         if(ScreenRoom(2)-P(4)-hWin<S{iScreen}(2)-S{iScreen}(4) )
            iScreen=mod(iScreen,nScreens)+1;
            ScreenRoom=S{iScreen} ;
         end
     end
 elseif(nargin==1)
   % Default Grid
    Grid{1}=[4 3];
    if(length(S)==1)
    else
        Grid{2}=[3 2];
    end
    setFigGrid(S,Grid,hWin)
elseif(nargin==2)
    % Using grid provided by the user on the first screen
    Grid{1}=[varargin{1} varargin{2}];
    setFigGrid(S,Grid,hWin);

elseif(nargin==3)
    % Using grid provided by the user on the screen requested by the user
    Grid{1}=[varargin{1} varargin{2}];
    S=S(varargin{3}); % that's the trick, here we select only one screen
    setFigGrid(S,Grid,hWin);
elseif(nargin==4)
  % Using grid provided by the user on screen 1 and 2
    Grid{1}=[varargin{1} varargin{2}];
    Grid{2}=[varargin{3} varargin{4}];
    setFigGrid(S,Grid,hWin);
else
    disp('wrong number or arguments');
end

function []=setFigGrid(S,G,hWin)
nG=length(G);
%compute Grid coordinates and store them in GP
for iG=1:nG
    dx=(S{iG}(3)-S{iG}(1))/G{iG}(1);
    dy=(S{iG}(4))/G{iG}(2)-hWin;
    cpt=0;
    for iy=1:G{iG}(2)
        for ix=1:G{iG}(1)
            cpt=cpt+1;
            GP{iG}(cpt,:)=[S{iG}(1)+(ix-1)*dx  S{iG}(2)-(iy)*dy-(iy)*hWin dx dy];
        end
    end
end



% 
iG=1;
nmax=length(GP{1}(:,1));
cpt=1;
figs=get(0,'children');
for i=1:length(figs)
    hfig=figs(length(figs)-i+1);  % fig handle
    set(hfig,'Position',GP{iG}(cpt,:));
    set(hfig,'Visible','on');
    cpt=cpt+1;
    if(cpt>nmax)
        iG=mod(iG,nG)+1;
        nmax=length(GP{iG}(:,1)) ;
        cpt=1;
     end
 end



