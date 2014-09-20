function C=fGray(varargin)
% returns an RGB gray color, the intensity can be given as an input argument between 0-1
% 0=black
% 1=white

% E. Branlard - February 2014
if nargin==0
    C=[0.4 0.4 0.4];
else
    c=varargin{1};
    C=[c c c];
end

