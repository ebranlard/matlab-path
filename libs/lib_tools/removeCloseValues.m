function [x]=removeCloseValues(x,x_sing,epsilon)
% remove values in x that are closer than epsilon to the singularities

% Looping on singularities
for i=1:length(x_sing)
    % Keeping the one far from the singularity..
    x=x(find(abs(x-x_sing(i))>epsilon));
end


