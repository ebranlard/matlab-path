function varargout= plot3b(P,varargin);
% plot3b takes as a first argument a Nx3 matrix of points to be ploted since plot3 is not smart enough to understand it.
if size(P,1)==3 && size(P,2)~=3
    P=P';
end
if nargout>0
    h=plot3(P(:,1),P(:,2),P(:,3),varargin{:});
else
    plot3(P(:,1),P(:,2),P(:,3),varargin{:});
end
% h=plot3(P(:,1),P(:,2),P(:,3));
