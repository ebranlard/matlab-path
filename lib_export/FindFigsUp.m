function [R D] = FindFigsUp(folder,pattern,depth,depthlim,dontfuckyourkid  )
  files=dir(folder);
  %disp(sprintf('Reading folder %s',folder));
  R=' ';
  D=' ';
  for i=1:length(files)
     if files(i).isdir && ~isequal(files(i).name,'.' ) && ~isequal(files(i).name,'..' )
         %disp(files(i).name)
         
         if ~isempty(strfind(lower(files(i).name),lower(pattern)))
            % disp(sprintf('Found : %s/%s',folder,files(i).name))
             R=strcat(R,' ! ',sprintf('%s/%s',folder,files(i).name));
             D=strcat(D,' ! ',num2str(depth));
         else
             if ~(depth==0 && isequal(files(i).name,dontfuckyourkid))
                if depth<depthlim
                     [RR DD]=FindFigsUp(sprintf('%s/%s',folder,files(i).name),pattern,depth+1,depthlim,'');
                     R=strcat(R,' ! ',RR);
                     D=strcat(D,' ! ',DD);
                end
             else
                % disp(sprintf('I''m not fuckking my kid %s',dontfuckyourkid))
             end
         end
     end
  end

end

