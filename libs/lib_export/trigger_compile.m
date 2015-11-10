function trigger_compile()
% perform compilation in a given folder
global FigurePath
if(~isempty(FigurePath))
    if iscell(FigurePath)
       f=fileparts(FigurePath{1});
   else
       f=fileparts(FigurePath);
   end
   f=f(1:end-4)
   if ispc()
       system(sprintf('make -C %s',f));
   else
       % I've run into some library loading errors 
       %system(sprintf('make -C %s',f));
       system(sprintf('xfce4-terminal -e "make -C %s"',f));
       %system(sprintf('xterm -e "make -C %s"',f));
  end
end
