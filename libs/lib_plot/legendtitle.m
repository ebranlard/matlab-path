function  varargout= legendtitle(varargin)
h=legend(varargin{2:end});
set(get(h,'title'),'string',varargin{1});
if(nargout==1) 
    varargout=h;
end

    

