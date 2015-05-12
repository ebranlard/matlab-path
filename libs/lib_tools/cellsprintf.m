function legd=cellsprintf(strpattern,v)
%cellsprintf takes different kind of second arguments and return a cell of strings
if iscell(v)
   legd=cellfun(@(x)sprintf(strpattern,x),v,'UniformOutput',0);
else
   legd=arrayfun(@(x)sprintf(strpattern,x),v,'UniformOutput',0);
end
