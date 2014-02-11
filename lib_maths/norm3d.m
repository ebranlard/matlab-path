function n=norm3d(M)
% norm3d: takes a matrix 3xn or nx3 and return the norm of each of the component. For instancve M contains coordinates of n points, or vectors, and the function return the norm of each of these points/vector
%
% Make M an matrix of 3 columns (might transpose it) 
M=checkNcolumns(M,3);

n=sqrt(M(:,1).^2+M(:,2).^2+M(:,3).^2);

