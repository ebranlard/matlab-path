% get_polynomial_string
% Ewan Machefaux 04/11/2010
% This function create a string showing the fitted polynomial equation from polyfit
%   Input 
%            p: polyfit coefficient vector
%            x_str: string to be used as x in y=ax^2+bx+c
%            y_str: string to be used as y= in y=ax^2+bx+c
%  Output: 
%           eq_str: corresponding string equation

%%

function eq_str=getPolynomialString(p,x_str,y_str)

for i=1:length(p)

    if (p(i)>=0)==0
        string{i}=[' ',num2str(p(i)),'*',x_str,'^',num2str(length(p)-i)];
    else
        string{i}=[' +',num2str(p(i)),'*',x_str,'^',num2str(length(p)-i)];
    end
    
    if i==length(p)
        if (p(i)>=0)==0
        string{i}=[' ',num2str(p(i))];
        else
        string{i}=[' +',num2str(p(i))];
        end
    end
end

eq_str=strcat(y_str,string{1:end});