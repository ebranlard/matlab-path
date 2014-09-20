function [hx,hy] = ...
    format_ticks(h,offsetx,offsety,varargin)

%define axis text offsetx (percentage of total range)
if ~exist('offsetx','var');
    offsetx = 0.02;
elseif length(offsetx) == 0;
    offsetx = 0.02;
end;

%define axis text offsety (percentage of total range)
if ~exist('offsety','var');
    offsety = 0.02;
elseif length(offsety) == 0;
    offsety = 0.02;
end;

%make sure the axis handle input really exists
if ~exist('h','var');
    h = gca;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SuperFirst : Save Xlabel position and value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hlabelx = get(h,'XLabel');
labelxpos=get(hlabelx,'pos');
hlabely = get(h,'YLabel');
labelypos=get(hlabely,'pos');
axispos = get(h,'Position');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% BEGIN: FIRST THE X-AXIS TICK LABELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tickx = get(h,'XTickLabel');
if ischar(tickx);
    temp = tickx;
    tickx = cell(1,size(temp,1));
    for j=1:size(temp,1);
        tickx{j} = ['$' strtrim( temp(j,:)) '$'];
    end
end


% erase the current tick label
set(h,'XTickLabel',{});
% tick positions
tickposx = get(h,'XTick');
tickposy = get(h,'YTick');

%set the new tick positions
set(h,'YTick',tickposy);
set(h,'XTick',tickposx);

%Convert the cell labels to a character string
%tickx = char(tickx);
tickx = cellstr(tickx);
%Make the XTICKS!
lim = get(h,'YLim');
if min(tickposy) < lim(1);
    lim(1) = min(tickposy);
end;
if max(tickposy) > lim(2);
    lim(2) = max(tickposy);
end;

hx = text(tickposx,...
    repmat(lim(1)-offsetx*(lim(2)-lim(1)),length(tickposx),1),...
    tickx,'HorizontalAlignment','center',...
    'VerticalAlignment','top','interpreter','LaTex','Parent',h); % MANU added parent
% 
%Get and set the text size and weight
set(hx,'FontSize',get(h,'FontSize'));
set(hx,'FontWeight',get(h,'FontWeight'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%END: FIRST THE X-AXIS TICK LABELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%BEGIN: NOW THE Y-AXIS TICK LABELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ticky = get(h,'YTickLabel');
temp = ticky;
ticky = cell(1,size(temp,1));
for j=1:size(temp,1);
    ticky{j} = strcat( ['$' strtrim( temp(j,:)) '$']); % MANU added strcat
end;


%get the x tick positions if the user did not input them
tickposy = get(h,'YTick');
%erase the current tick label
set(h,'YTickLabel',{});
%set the new tick positions
set(h,'YTick',tickposy);

set(h,'Position',axispos);



%Convert the cell labels to a character string
%ticky = char(ticky);
try
    ticky = cellstr(ticky);
catch
    % MANU Sometimes there are cells in-bricated into cells, we need to flatten that
    temp2=ticky
    for j=1:length(temp2);
        ticky{j} = strcat(temp2{j}{:});
    end;

end
%Make the YTICKS!
lim = get(h,'XLim');
if min(tickposx) < lim(1);
    lim(1) = min(tickposx);
end;
if max(tickposx) > lim(2);
    lim(2) = max(tickposx);
end;

hy = text(...
    repmat(lim(1)-offsety*(lim(2)-lim(1)),length(tickposy),1),...
    tickposy,...
    ticky,'VerticalAlignment','middle',...
    'HorizontalAlignment','right','interpreter','LaTex','Parent',h); % MANU added parent


%%

%Set the additional parameters if they were input
if length(varargin) >= 2;
    command_string = ['set(hx'];
    for j=1:2:length(varargin);
        command_string = [command_string ',' ...
            '''' varargin{j} ''',varargin{' num2str(j+1) '}'];
    end;
    command_string = [command_string ');'];
    eval(command_string);
end;
%Set the additional parameters if they were input
if length(varargin) >= 2;
    command_string = ['set(hy'];
    for j=1:2:length(varargin);
        command_string = [command_string ',' ...
            '''' varargin{j} ''',varargin{' num2str(j+1) '}'];
    end;
    command_string = [command_string ');'];
    eval(command_string);
end;

%% Resetting the Xlabel and Ylabel
set(hlabelx,'pos',labelxpos);
set(hlabely,'pos',labelypos);

