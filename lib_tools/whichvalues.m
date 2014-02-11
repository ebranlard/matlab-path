function i=whichvalues(x,v)
    I=1:length(x);
    if(length(v)==1)
        i=I(x==v);
    else
    error('Anyway I should rethink the nanme of this function')
    end
end
