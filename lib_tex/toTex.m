function [t] = toTex(s)
% Takes a matlab string and return it into latex
% Calls python script TexForm
s=regexprep(s,'\^','**');
s=regexprep(s,'1','ONE');
s=regexprep(s,'2','TWO');
s=regexprep(s,'3','THREE');
s=regexprep(s,'4','FOUR');
s=regexprep(s,'5','FIVE');
s=regexprep(s,'6','SIX');
s=regexprep(s,'7','SEVEN');
s=regexprep(s,'8','EIGHT');
s=regexprep(s,'9','NINE');
s=regexprep(s,'0','ZERO');
t=python('TexForm.py',s);
t=regexprep(t,'ONE','1');
t=regexprep(t,'TWO','2');
t=regexprep(t,'THREE','3');
t=regexprep(t,'FOUR','4');
t=regexprep(t,'FIVE','5');
t=regexprep(t,'SIX','6');
t=regexprep(t,'SEVEN','7');
t=regexprep(t,'EIGHT','8');
t=regexprep(t,'NINE','9');
t=regexprep(t,'ZERO','0');

t=regexprep(t,'\$','');
t=['\eq ' t '\eqf'];
