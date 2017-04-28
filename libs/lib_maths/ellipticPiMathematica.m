function Pi = ellipticPi(varargin)
% Emmanuel Branlard : October 2013
% Calls mathematica to get the value of the elliptic integral of the third kind
% This uses a script called ElliptciPiMathematica.m which should be in your binary path in linux

% ellipticPi(n,m)
% ellipticPi(n,m,phi)

if(nargin==2)
    n=varargin{1};
    m=varargin{2};
    %     phi=pi/2;
    % elseif(nargin==3)
    %     error('input 2 arguments')
    %     n   = varargin{1} ; 
    %     phi = varargin{2} ; 
    %     m   = varargin{3} ; 
else
    error('Input 2 arguments')
end
% Flattening vectors
nFlat=reshape(n,1,[]);
mFlat=reshape(m,1,[]);

Iinf=(nFlat==Inf);
n_inf=sum(Iinf);
if n_inf>0
    warning('%d infinity values found in vector n',n_inf);
    nFlat(Iinf)=0.1; % we replace by a reasonable value (it will be substitued later by 0)
end

n_args=length(nFlat);
Piflat=zeros(1,n_args);
%% We have problems if number of arguments > 7000
% we partition by chunks
chunk_size=7000;
n_chunk=floor(n_args/chunk_size)+1;
count_errors=0;
for i=1:n_chunk
    % Indexes of the chunk i
    I=((i-1)*chunk_size+1):min(n_args,i*chunk_size);
    % writing numbers in one long string (first n then m)
    numbers=sprintf('%f ',nFlat(I),mFlat(I));
    % creating a system call where numbers are in argument
    command=sprintf('EllipticPiMathematica.m %s',numbers);
    %     command=sprintf('EllipticPiMathematica.sh %s',numbers);
    % Actually doing the call
    %     try
    [~,res]=system(command);

    % Scanning terminal output
    try
        % Fast reading
        PiFlat(I)=sscanf(res,'%f')';
    catch
        warning('Sscanf returned error, using slow interpreter.\nThis should not happen now since mathematica script has been tuned to returned NaN')
        % Slower interpretation of terminal output, but more flexible...
        C=strsplit(res);
        for ic=1:length(C)
            try
                PiFlat(I(ic))=sscanf(C{ic},'%f')';
            catch
                count_errors=count_errors+1;
                if isequal(C{ic},'ComplexInfinity')
                    PiFlat(I(ic))=NaN;
                else
                    disp(C{ic})
                end
            end
        end
    end
end
if count_errors>0
    warning(sprintf('%d/%d wrong values returned by mathematica',count_errors,n_args))
end
n_nan=sum(isnan(PiFlat));
if n_nan>0
    warning(sprintf('%d/%d NaN values returned by mathematica',n_nan,n_args))
end

%% Finalizing
if ~isempty(Iinf)
    % we substitue with 0
    PiFlat(Iinf)=0;
end

% reshaping
if(length(PiFlat)~=length(mFlat))
    warning('Error in interpreting mathematica output. \nReturning NaN instead !!!!')
    PiFlat=0*mFlat+NaN;
    %   kbd
end
% kbd
Pi=reshape(PiFlat,size(m));
