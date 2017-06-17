function [ S ] = fcellstrcat( s )
% NOTE: I should have used cellfun, of [s{:}]

% --- Tests
if nargin==0
    fcellstrcat('a')
    fcellstrcat(['a','b'])
    fcellstrcat({'a'})
    fcellstrcat({'a','b'})
    fcellstrcat({['a','b'],'b'})
    fcellstrcat({ {'a','b'} , {'c'},'d' })
end

% --- Core
if(iscell(s))
    S='';
    for i=1:length(s)
        S=strcat(S,sstrcat(s{i}) );
    end
else
    S=s;
end
end


