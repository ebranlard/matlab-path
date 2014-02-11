function s=mat2cellstr(x)
% Converts matrix to cellstring
% s=regexp(num2str(v), '\s*', 'split'); %does not work with matrices
s=arrayfun(@num2str, x, 'unif', 0); %works with matrix
