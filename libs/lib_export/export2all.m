function export2all(constrained)
if nargin < 1
    constrained =  0;
end
export('png',constrained)
export('pdf',constrained)
export('eps',constrained)
end