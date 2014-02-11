function [IDs Deltas] = findID(x, xtarget )
% Returns:
% IDs: position in vectors x that are closest to each value of the xtarget vector
% Deltas: how far off are we from the target
    IDs=zeros(1,length(xtarget));
    Deltas=zeros(1,length(xtarget));
    for i=1:length(xtarget)
        [m ID]=min(abs(x-xtarget(i)));
        Deltas(i)=(m-xtarget(i))/xtarget(i);
        IDs(i)=ID;
    end
end

