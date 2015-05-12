function log_warning(msg)
    cprintf([1,0.5,0],sprintf('Warning: %s\n',msg));
    print_callee(1,1)
end

