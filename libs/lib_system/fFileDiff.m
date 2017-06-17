function b=fFileDiff(fn1,fn2)
    % Very simple diff based on string comparison
    % Author: E. Branlard
f1=fileread(fn1);
f2=fileread(fn2);
b=strcmp(f1,f2);
