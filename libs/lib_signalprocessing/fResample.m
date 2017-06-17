function M_out = fResample(M,t_ref,dt_ref,dt_old,method)
%  We resample such that the value at t is the mean of all the data within [t-dt/2 ; t+dt/2[
% NOTE: this function is extremely slow but it does its job
%
% Author: E. Branlard
% 
%% Optional arguments
if ~exist('method','var'); method= 'manual'; end;


%% Unit tests
if nargin==0
    M=zeros(10,2);
    M(:,1)=0:9;
    t_ref=1:2:9;
    dt_ref=2;
    dt_old=1;
    y = fResample(M,t_ref,dt_ref,dt_old)
    return
end


%% Local variables

t_in   = M(:,1)       ;
tol    = dt_ref/20    ; % 1 % of sampling time to compare time_stamps
tol_in = dt_old/20    ; % 1 % of sampling time to compare time_stamps
nt_ref = length(t_ref);

M_out  = nan(nt_ref,size(M,2));


%% Safety checks
if dt_ref<dt_old
    error('Oversampling not implemented')
end

% --- T_ref should be a vector of equidistant time steps
ddt=diff(t_ref);
if any(ddt)<=0
    error('Time ref should be monotically increasing')
elseif any(ddt-dt_ref+tol<0)
    error('Time ref should be a vector of with equidistant time steps')
end
% --- T_in should be a vector of increasing time steps
ddt=diff(t_in);
if any(ddt)<=0
    error('Time of input should be monotically increasing')
    % Alternatively, remove the points where diff=0
end

%% Narrowing resolution of time to n per dt_old time steps
nResolution = 4; % e.g., 4 means using a resolution of 4 per integer (ie 0 0.25 0.5 0.75 1)
% Floating point time index
TimeIndex_f= (t_in -t_in(1))/dt_old;
% Narrowing resolution
TimeIndex_f= round(TimeIndex_f*nResolution)/nResolution;
% Now converting to integers
TimeIndex   = round(TimeIndex_f);
%FullIndex   = floor((t_ref-t_ref(1))/sampling)+1; % not safe due to floating point
if TimeIndex(1)~=0
    disp('Time Index(1) should be zero')
    keyboard
end


t_in=TimeIndex*dt_old+t_in(1);
% keyboard





%% Manual expensive for loop method
if isequal(method,'manual')

    for it = 1:nt_ref
        t = t_ref(it);
        I = find(t_in>= t-dt_ref/2  & t_in < t+dt_ref/2);
        M_out(it,2:end)=nanmean(M(I,2:end),1); % mean row-wise (dim=1)
    end

elseif isequal(method,'filter')
    % --- T_in should be a vector of equidistant time steps for filter method to work
    ddt=diff(t_in);
    if any(ddt-dt_old+tol_in<0)
        error('Time ref should be a vector of with equidistant time steps')
    end


    % Filter assumes that the input vector is a regular vector
    n=round(dt_ref/dt_old);
    filter_mask= repmat(1/n,1,n);


    % NOTE: More work needed (here we assume that t_in and t_ref starts at the same time)
    istart = find(abs(t_in-t_ref(1))<tol,1,'first');
    if istart~=1
        error('Function to imnprove');
    end

    for icol=1:size(M,2)
        tmp = filter(filter_mask,1,M(:,icol));
        tmp = tmp(istart:n:end);
        ntmp=length(tmp);
        if ntmp<nt_ref
            M_out(1:ntmp,icol)  =tmp;
        else
            M_out(1:nt_ref,icol)=tmp(1:nt_ref);
        end
    end
%     t_avg   = t(6:6:end-1)+5*60/(3600*24); % adding 5 min due to some kind of offset

elseif isequal(method,'manualb')

    %% We work in the Index space such that
    % 1 is t_ref(1)-dt/2
    % 2 is t_ref(1)+dt/2
    %
    TimeIndex_f= (t_in -t_ref(1)-dt_ref/2)/dt_ref;
    % Narrowing resolution
    nResolution = 4; % e.g., 4 means using a resolution of 4 per integer (ie 0 0.25 0.5 0.75 1)
    TimeIndex_f= round(TimeIndex_f*nResolution)/nResolution;
    % Now converting to integers
    TimeIndex   = floor(TimeIndex_f)+2;

    disp('not finished')
    keyboard


end

%%
M_out(:,1)=t_ref;
