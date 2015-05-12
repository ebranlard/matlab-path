function err(msg)
if nargin==0
    msg=''
end

cprintf([1,0,0],sprintf('Error  : %s\n',msg));
print_callee(1);
