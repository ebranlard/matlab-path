function export2png(constrained)
if nargin < 1
    constrained =  0;
end
export('tkz',constrained)
end
