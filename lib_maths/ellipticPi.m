function Pi = ellipticPi(varargin)
% Emmanuel Branlard : October 2013
% Calls mathematica to get the value of the elliptic integral of the third kind
% This uses a script called ElliptciPiMathematica.m which should be in your binary path in linux

% ellipticPi(n,m)
% ellipticPi(phi,n,m)

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
if ~isempty(Iinf)
    warning('Infinity value found in vector n')
    nFlat(Iinf)=0.1; % we replace by a reasonable value
end

% writing numbers in one long string (first n then m)
numbers=sprintf('%f ',nFlat,mFlat);
% creating a system call where numbers are in argument
command=sprintf('EllipticPiMathematica.m %s',numbers);
% Actually doing the call
[a,res]=system(command);
% Scanning terminal output
PiFlat=sscanf(res,'%f')';

if ~isempty(Iinf)
    % we substitue with 0
    PiFlat(Iinf)=0;
end

% reshaping
if(length(PiFlat)~=length(mFlat))
  warning('Error in interpreting mathematica output. \nReturning NaN instead !!!!')
  PiFlat=0*mFlat+NaN;
end
% kbd
Pi=reshape(PiFlat,size(m));

