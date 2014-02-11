function l=lasts(M)
    s=size(M);
    l=zeros(1,s(1));
    for i=1:s(1)
        p=nonzero(M(i,:));
        l(i)=p(length(p));
    end
end