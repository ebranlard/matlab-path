function [ S ] = cellstrcat( s )
% I should have used cellfun
if(iscell(s))
    S='';
    for i=1:length(s)
        S=strcat(S,sstrcat(s{i}) );
    end
else
    S=s;
end
end


%  sstrcat('a')
%  sstrcat(['a','b'])
%  sstrcat({'a'})
%  sstrcat({'a','b'})
%  sstrcat({['a','b'],'b'})
%  sstrcat({ {'a','b'} , {'c'},'d' })
