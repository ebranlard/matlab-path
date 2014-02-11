% Debugging command that uses matlab "keyboard" function but gives more info and link to where it stops
% 
% E. Branlard - October 2012

disp('---------------------------------- Debug Mode --------------------------------------')
%     disp('Shift-F5 or return to quit ')
%     disp('F5 to go to next step')
% p = mfilename('fullpath') 
% p = mfilename() 

disp('Tools: stakk compare comp_struct')
stk=dbstack();
if length(stk)>1
    nline=stk(2).line;
    file=stk(2).file;
    [~,fname]=fileparts(file);
    fprintf('<a href="matlab: opentoline(''%s'',%d,1)">%s: line %d</a>',file,nline,fname,nline);
    if length(stk)>2
        nline     = stk(3).line     ; 
        file      = stk(3).file     ; 
        [~,fname] = fileparts(file) ; 
        fprintf(' < <a href="matlab: opentoline(''%s'',%d,1)">%s: line %d</a>',file,nline,fname,nline);
    end
    if length(stk)>3
        nline     = stk(4).line     ; 
        file      = stk(4).file     ; 
        [~,fname] = fileparts(file) ; 
        fprintf(' < <a href="matlab: opentoline(''%s'',%d,1)">%s: line %d</a>',file,nline,fname,nline);
    end
%    fprintf('%s: line %d -',fname,stk(2).line)
   fprintf('\n');
end
keyboard
