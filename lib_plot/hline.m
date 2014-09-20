function hline(vy,varargin)
% Adds horizontal line(s) to a plot at location vy
%
% E. Branlard - February 2014
%
for y=vy
    line(get(gca(),'XLim'),[y y],varargin{:})
end
