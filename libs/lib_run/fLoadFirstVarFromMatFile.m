function x=fLoadFirstVarFromMatFile(matfile,bSilent)
    % Loads the FIRST variable found within a .mat file and returns it
if ~exist('bSilent','var'); bSilent=false; end;

if ~bSilent
fprintf('Loading matfile %s ...',matfile);
end
A=load(matfile); % A is a struct

FieldNames= fieldnames(A);

if ~bSilent
fprintf('\b\b\b\b - Getting field %s ...',FieldNames{1})
end


x =A.(FieldNames{1});


if ~bSilent
fprintf('\b\b\b\b Done\n');
end
    
