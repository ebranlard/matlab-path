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
   system(sprintf('make -C %s',f));
end
