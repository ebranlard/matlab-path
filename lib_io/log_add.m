function []=log_add(file,msg)
fid=fopen(file,'a');
fprintf(fid,'%s\n',msg);
fclose(fid);
end