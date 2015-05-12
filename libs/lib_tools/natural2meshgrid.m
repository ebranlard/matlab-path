function y=natural2meshgrid(x,n1,n2,n3)
if n3==0
    y=permute(reshape(x,[n2,n1]),[2,1]);
else
    y=permute(reshape(x,[n3,n2,n1]),[2,3,1]);
end
