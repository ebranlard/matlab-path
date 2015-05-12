function print_callee(varargin)
% print_callee: print the caller/callee stack from a given level
% print_callee(start_level)
% print_callee(start_level,stack_length)
%
% print_callee(0) will print the whole stack (omitting the function print_callee) DEFAULT
% print_callee(1) will print the stack (omitting the function print_callee and the script calling print_callee)
% print_callee(0,1) will print only one stack 
O2L='/home/manu/Geekeries/_Programming/Matlab/MatlabPath/lib_run/';


stk=dbstack();
stack_length=length(stk);
level=0;

if nargin>=1
    level=varargin{1};
    if nargin==2
       stack_length=varargin{2};
   end
end

rel_level=2+level;
max_level=min(rel_level+stack_length-1, length(stk));



for is=rel_level:max_level
    nline=stk(is).line;
    file=stk(is).file;
    [~,fname]=fileparts(file);
    if ~isequal(file,'run.m')
        if(is==rel_level)
            indent='     In:';
        else
            indent=' < ';
        end
        fprintf('%s<a href="matlab: o2l(''%s'',%d,1)'';">%s:%d</a>',indent,file,nline,fname,nline);
    end

end
fprintf('\n');
