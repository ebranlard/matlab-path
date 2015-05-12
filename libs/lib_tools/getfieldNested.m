function  X = getfieldNested(S,name);
[~,~,~,~,~,~,l]=regexp(name,'[.]');
buff=S;
for i=1:length(l)
    buff=getfield(buff,l{i});
end
X=buff;

