function varargout=clim(varargin)

disp('You typed clim, you meant caxis?')
if nargout>0
    h=caxis(varargin{:})
else
    caxis(varargin{:})
end
