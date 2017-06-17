function [y,nPeaksRemoved,nTimeStampRemoved,nPeaksTotal]=fFilterPeaksWithAbsoluteThreashold(x,Threashold,nMin,nMax,nSurrounding,JumpFactor)
% Remove peaks in a signal if all the following conditions are met:
%  - the value is above a certain threashold
%  - the threashold is exceeded for minimum nMin continuous values and maximu nMax continuous values
%  - meanPeak > mean(Surrounding)*JumpFactor: (the average value of the peak) is above (JumpFactor times the mean value of its surrounding).
%
% This is typically used to filter peaks in the standard deviation
%
%
% Author: E. Branlard

%
y=x;

% Retrieving intervals where x is above a threashold
Its = fGetIntervals( x>Threashold );

nPeaksRemoved=0;
nTimeStampRemoved=0;

nPeaksTotal=size(Its,1);
% We loop on intervals
for i=1:nPeaksTotal
    bDiscarded=false;

    % Peak interval
    IPeak=Its(i,2):Its(i,3);

    % Surrounding interval
    ISurround = [(-nSurrounding:-1)+Its(i,2) (1:nSurrounding-1)+Its(i,3)];
    ISurround = ISurround(ISurround>0);
    ISurround = ISurround(ISurround<length(x));

    %
    IAll = min(ISurround):max(ISurround);

    % Selecting intervals of sufficient length
    if Its(i,1)<=nMax && Its(i,1)>=nMin

        % computing mean of the peak
        meanPeak=mean(x(IPeak));

        %computing mean of the surrounding 

        meanSurround=nanmean(x(ISurround));

%         disp([meanPeak meanSurround meanPeak/meanSurround])
        % Selection based on the jump factor
        if meanPeak > meanSurround * JumpFactor
            y(Its(i,2):Its(i,3))=NaN;
            nPeaksRemoved=nPeaksRemoved+1;
            nTimeStampRemoved=nTimeStampRemoved+Its(i,1);
            bDiscarded=true;
        end
    end
%     if ~bDiscarded
%         figure, hold all
%         title(['This peak was kept - ID ',num2str(Its(i,1))]);
%         plot(IAll,x(IAll),'-');
%         plot(ISurround,x(ISurround),'+');
%         plot(IPeak,x(IPeak),'o');
%     end

end
