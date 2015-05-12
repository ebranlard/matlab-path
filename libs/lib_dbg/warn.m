function warn(msg)
if nargin==0
    msg=''
end

cprintf([1,0.5,0],sprintf('Warning: %s\n',msg));
print_callee(1);
