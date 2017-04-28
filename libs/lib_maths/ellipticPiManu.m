function Pi = ellipticPiManu(varargin)
    %> Compute the elliptic integral of the third kind using Gauss-Legendre quadrature
    % Just like matlab function ellipticPi(n,phi,m) BUT PHI IN DEGREES
    % Use phi=90 for complete elliptic integral Pi
    %   Pi(n,m,phi) = int(1/((1 - n*sin(t)^2)*sqrt(1 - m*sin(t)^2)), t=0..phi)

    % ellipticPi(n,m)
    % ellipticPi(phi,n,m)

    if(nargin==2)
        vn = varargin{1};
        vm = varargin{2};
        vphi=ones(size(vn))*90;
    elseif(nargin==3)
        % ok
        vn   = varargin{1};
        vphi = varargin{2};
        vm   = varargin{3};
    else
        error('Input 2 or 3 arguments')
    end

    % ! For Elliptic pi
     T=[.9931285991850949e0,.9639719272779138e0, .9122344282513259e0,.8391169718222188e0, .7463319064601508e0,.6360536807265150e0, .5108670019508271e0,.3737060887154195e0, .2277858511416451e0,.7652652113349734e-1];
    W=[.1761400713915212e-1,.4060142980038694e-1, .6267204833410907e-1,.8327674157670475e-1, .1019301198172404e0,.1181945319615184e0, .1316886384491766e0,.1420961093183820e0, .1491729864726037e0,.1527533871307258e0];

    vk =sqrt(vm);
    vc=vn;


    Pi=zeros(size(vn));
    for ii=1:length(vn)
        k   = vk(ii)  ;
        c   = vc(ii)  ;
        phi = vphi(ii);

        lb1= k==1  && abs(phi-90.0)<=1.0e-8;
        lb2= c==1  && abs(phi-90.0)<=1.0e-8;
        if  lb1 || lb2 
            Pi(ii)=Inf;
        else
            c1=0.87266462599716d-2*phi;
            c2=c1;
            Pi(ii)=0.0;
            for i=1:10
                c0=c2*T(i);
                t1=c1+c0;
                t2=c1-c0;
                f1=1.0/((1.0-c*sin(t1)*sin(t1))*sqrt(1.0-k*k*sin(t1)*sin(t1)));
                f2=1.0/((1.0-c*sin(t2)*sin(t2))*sqrt(1.0-k*k*sin(t2)*sin(t2)));
                Pi(ii)=Pi(ii)+W(i)*(f1+f2);
            end
            Pi(ii)=c1*Pi(ii);
        end
    end % loop on values
