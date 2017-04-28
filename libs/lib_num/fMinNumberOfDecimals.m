function [n, sFormat]=fMinNumberOfDecimals(v,nMax)
    % Returns the miminum number of decimal required to print all the float numbers given in v
    % 
    % --- Optional arguments
    if ~exist('nMin','var'); nMax=6; end;
    % --- Test case
    if nargin==0
        v=[0 1 100.2 123.0 0.1 0.001 -2 -2.2 1/3];
    end

    n=0;
    while n<nMax
        v=abs(v-fix(v));
        % Weird bug when v is close to 1, fix doesnot return 1...
        if abs(v-1) <10^(-nMax-2)
            v=abs(v-1);
        end
        % 
        if any( v>10^(-nMax-2))
            v=v*10;
        else
            break
        end
        n=n+1;
    end
    sFormat=sprintf('%%.%df',n);
end
