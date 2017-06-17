function M_out=fFillTimeGapsWithNaNs(signame,M_in,t_ref,method)
% Takes a matrix which first column is a timestamp and fills it with NaNs such as the timestamp matches t_ref
% Author: E. Branlard

fprintf('Filling  %5s:',signame);

%% Optional arguments
if ~exist('method','var')
    method='time_index';
end

%%  Initialization of variables
t_ref    = t_ref(:)              ; 
t_in     = M_in(:,1)             ;
sampling = (t_ref(2)-t_ref(1))   ; % 
tol      = (t_ref(2)-t_ref(1))/20; % 1 % of sampling time to compare time_stamps
% By deafult the output matrix is filled with NaNs
M_out = nan(length(t_ref),size(M_in,2));
% timestamp is copied in fist column
M_out(:,1)= t_ref ; 


%% Safety checks:
% Round each measured time to nearest sp
fprintf('t_in : %s->%s ',datestr(M_in(1,1),'mm/yy'),datestr(M_in(end,1),'mm/yy'));
fprintf('t_ref: %s->%s ',datestr(t_ref(1) ,'mm/yy'),datestr(t_ref(end) ,'mm/yy') );

delta=t_in(1)-t_ref(1);
if  delta<0 && abs(delta)>tol
    error('This function assumes that the input vector starts after the start of t_ref')
end
delta=t_in(end)-t_ref(end);
if  delta>0 && abs(delta)>tol
    error('This function assumes that the input vector ends before the end of t_ref')
end

% - T_ref should be a vector of equidistant time steps
ddt=diff(t_ref);
if any(ddt)<=0
    error('Time ref should be monotically increasing')
elseif any(ddt-sampling+tol<0)
    error('Time ref should be a vector of with equidistant time steps')
end
% - T_in should be a vector of increasing time steps
ddt=diff(t_in);
if any(ddt)<=0
    error('Time of input should be monotically increasing')
    % Alternatively, remove the points where diff=0
end
%% Filling the gaps
n_skipped=0;
if isequal(method,'manual')
    i_in=1;
    for i_out=1:length(M_out(:,1))
        if i_in>length(M_in(:,1))
            break
        end
        delta=t_in(i_in) - t_ref(i_out);
        % If the input is close to the output time stamp, assign it
        if abs(delta)<=sampling/2
            M_out(i_out,2:end)=M_in(i_in,2:end);
            i_in=i_in+1;
        elseif delta<0 && (-delta)>sampling/2
            % --- "Removing duplicates" if any in the input vector
            % (If some datapoints are too close and thus do not respect the samplint then 
            % the input is behind the output, so we catch up and skipp those weird data)
           while delta<0 && (-delta)>sampling/2
                n_skipped=n_skipped+1;
                i_in=i_in+1;
                delta=t_in(i_in) - t_ref(i_out);
            end
            if abs(delta)<=sampling/2
                M_out(i_out,2:end)=M_in(i_in,2:end);
                i_in=i_in+1;
            end
        end
    end
elseif isequal(method,'time_index')
    % Floating point time index
    TimeIndex_f= (t_in -t_ref(1))/sampling;
    % Using a resolution of 4 per integer (ie 0 0.25 0.5 0.75 1)
    TimeIndex_f= round(TimeIndex_f*4)/4;
    % Now converting to integers
    TimeIndex   = round(TimeIndex_f)+1;
    %FullIndex   = floor((t_ref-t_ref(1))/sampling)+1; % not safe due to floating point
    FullIndex   = 1:length(t_ref);
    % --- Removing duplicates if any in the input vector
    [TimeIndex_u,I_u] = unique(TimeIndex);
    n_skipped=length(TimeIndex)-length(TimeIndex_u);
    M_in=M_in(I_u,:);
    % --- Positions in out that match in
    SearchIndex = ismember(FullIndex,TimeIndex_u);
    M_out(SearchIndex,2:end) = M_in(:,2:end);
elseif isequal(method,'n')
    % Taken from MoreTimeMatch
    
    %Finding nearest match in time
    index_in         = 1:length(t_in)                                 ;
    index_in_matched = interp1(t_in,index_in,t_ref,'nearest','extrap');
        
    % calculate time difference between reference and matched timestamp
    dt       = NaN(length(t_ref),1)                ;
    temp     = ~isnan(index_in_matched)            ;
    dt(temp) = t_in(index_in_matched(temp))-t_ref(temp);

    tback  = sampling/2;
    tahead = sampling/2;
    
    % if time difference is too big, reject match
    temp= dt< -tback | dt> tahead;
    index_in_matched(temp)=NaN;

    % generate output matrix
    temp=~isnan(index_in_matched);
    M_out(temp,2:end) = M_in(index_in_matched(temp),2:end);
else
    error('Unknown method')
end
if n_skipped>0
    fprintf('- %d input timestamps skipped ',n_skipped);
end

% Counting before and after number of nans
n_nan_in  = sum(isnan(M_in(:,2)));
n_nan_out = sum(isnan(M_out(:,2)));
fprintf('- %d timestamps inserted\n',n_nan_out-n_nan_in);
