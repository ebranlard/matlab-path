function y=mywblpdf(x,a,b)
    y=b*a^(-b)* x.^(b-1) .* exp(-(x/a).^b);
    y(x<0)=0;
end
