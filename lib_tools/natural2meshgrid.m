function y=natural2meshgrid(x,n1,n2,n3)
y=permute(reshape(x,[n3,n2,n1]),[2,3,1]);
