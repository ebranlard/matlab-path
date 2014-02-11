function [ Path ] = FindFigsInterpreter( splitStrR , splitStrD )
    Path='';
    [m i]=min(str2double(splitStrD));
    if length(splitStrR{i})>1
        Path=splitStrR{i};
    end
end

