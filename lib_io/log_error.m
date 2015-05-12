function log_error(msg)
    cprintf([1,0,0],sprintf('Error  : %s\n',msg));
    print_callee(1)
end

