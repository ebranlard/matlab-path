function floglogMarked(x,y,n,style_line,style_marker,varargin)

    if iscell(n) 
        xi=cell2mat(n);
    else
        % n Equidistant positions within x
        xi=linspace(min(x),max(x),n+2);
        xi=xi(2:end-1);
    end
    % Interpolating y at those values
    yi=interp1(x,y,xi);


    % Removing LineWidth if present 


    % Plot for legend 
    loglog ( xi(1) , yi(1) , [style_line style_marker] , 'handlevisibility' , 'on'  , varargin{:} ),  hold on

    % full data
    loglog ( x  , y  , style_line              , 'handlevisibility' , 'off' , varargin{:} ) 
    % Just the markers
    if length(style_marker)>0
        loglog ( xi , yi , style_marker              , 'handlevisibility' , 'off' , varargin{:} ) 
    end

%     if isempty(varargin)
%         plot(xi,yi,'+','handlevisibility','off')
%     else
%         plot(xi,yi,varargin{:})
%     end

