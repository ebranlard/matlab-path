function y2=fMovingAverage(y,w,varargin)

%% Default arguments 
direction   = 'centered';
nan_method  = 'none'    ;
algorithm   = 'naive'   ;
directional = false     ;

% --------------------------------------------------------------------------------
% --- Unit tests 
% --------------------------------------------------------------------------------
if nargin==0

    fMovingAverage([1 2 3 3 3 3 2 1],1,'direction','centered')
    fMovingAverage([1 2 3 3 3 3 2 1],2,'direction','centered')
    fMovingAverage([1 2 3 3 3 3 2 1],3,'direction','centered')
    fMovingAverage([1 2 3 3 3 3 2 1],4,'direction','centered')
    yy=rand(1,500000);
    tic()
    M=fMovingAverage(yy,6);
    toc()


    return;
end

% --------------------------------------------------------------------------------
% --- Arguments 
% --------------------------------------------------------------------------------

%% Handling pais of arguments
nargs=length(varargin);
if mod(nargs,2)~=0;
    error('Arguments should be given in pairs:   variable name,value ');
end

for iarg=1:2:nargs
    switch lower(varargin{iarg})
        case 'direction'
             direction=varargin{iarg+1};
        case 'nan_method'
             nan_method=varargin{iarg+1};
        otherwise 
            error('Unrecognized argument %s',varargin{iarg})
    end
end



% --------------------------------------------------------------------------------
% --- Different options 
% --------------------------------------------------------------------------------
%% Nan handling
if isequal(nan_method,'lin_interp')
    % Replacing Nan values by linear interpolation
    bNan=isnan(y);
    xi = find(~bNaN);
    yi = y(~bNan)  ;
    y  = interp1(xi,yi,1:length(y),'linear');
end
%



% --------------------------------------------------------------------------------
% --- Preprocessing of data 
% --------------------------------------------------------------------------------
%%
if directional
    error('directional todo');
else
    y2=nan(size(y));
end

% --------------------------------------------------------------------------------
% ---  Algorithm
% --------------------------------------------------------------------------------
switch lower(algorithm)
    case 'naive'
        %% Direction
        if isequal(direction,'centered')
            w_back=floor(w/2);
            w_forw=floor(w/2);
            if mod(w,2)==0 % even number
                w_forw=w_forw-1;
            end
        end
        if length(-w_back:w_forw)~=w
            error('wrong window size')
        end
        %% Naive for loop
        n=length(y);
        for i=1:n
            i1=max(1,i-w_back);
            i2=min(n,i+w_forw);
            y2(i)=mean(y(i1:i2));
        end

    otherwise
        error('Unknwon algorithm %s',algorithm)
end


%%
% --------------------------------------------------------------------------------
% --- Postprocessing of data 
% --------------------------------------------------------------------------------
%%
if directional
    error('directional todo');
end
