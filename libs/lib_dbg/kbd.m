% Debugging command that uses matlab "keyboard" function but gives more info and link to where it stops
% 
% E. Branlard - October 2012

disp('---------------------------------- Debug Mode --------------------------------------')
%     disp('Shift-F5 or return to quit ')
%     disp('F5 to go to next step')
% p = mfilename('fullpath') 
% p = mfilename() 

disp('Tools: stakk compare comp_struct');
print_callee(1);
keyboard
