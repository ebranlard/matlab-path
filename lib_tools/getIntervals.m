function [ Its ] = getIntervals( IB )
% Author: Manu

% Returns an array describing the intervals within the input vector
% [ intervallength  istart  iend ;
%
% Its = getIntervals( IB )
% IB is a logical vector of 0s and 1s
%
% Examples / Test :
% getIntervals([0])==[]
% getIntervals([1])==[1 1 1]
% getIntervals([0 1])==[1 2 2]
% getIntervals([1 0])==[1 1 1]
% getIntervals([1 1])==[2 1 2]
% getIntervals([0 1 0])==[1 2 2]
% getIntervals([0 1 1])==[2 2 3]
% getIntervals([1 1 0])==[2 1 2]
% getIntervals([1 0 1])==[1 1 1; 1 3 3]
% 
%
if(sum(IB)==0)
    Its=[];
else
    if(sum(IB)==1)
        Idx=whichvalue(IB,1);
        Its=[1 Idx Idx];
    else
        Idx=1:length(IB);
        Idx=Idx(logical(IB));
        delta_Idx=diff(Idx);
        jumps=1:length(delta_Idx);
        jumps=jumps(delta_Idx>1);
        if(isempty(jumps))
            Its=[Idx(end)-Idx(1)+1 Idx(1) Idx(end)];
        else
            istart=Idx(1);
            Its=zeros(length(jumps)+1,3);
            for i=1:length(jumps)
                iend=Idx(jumps(i));
                Its(i,1:3)=[iend-istart+1 istart iend];
                istart=Idx(jumps(i)+1);
            end
            Its(end,1:3)=[Idx(end)-istart+1 istart Idx(end)];    
        end
end

end

