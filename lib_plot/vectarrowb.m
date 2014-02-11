function vectarrowb(p0,p1,scale,col,linewidth,arrowlength,arrowangle)
%Arrowline 3-D vector plot.
%   vectarrow(p0,p1) plots a line vector with arrow pointing from point p0
%   to point p1. The function can plot both 2D and 3D vector with arrow
%   depending on the dimension of the input

%   Adapted by E. Branlard from Rentian Xiong 4-18-05
%   
%

  if max(size(p0))==3
      if max(size(p1))==3
          x0 = p0(1);
          y0 = p0(2);
          z0 = p0(3);
          x1 = p1(1);
          y1 = p1(2);
          z1 = p1(3);
          plot3([x0;x1],[y0;y1],[z0;z1]);   % Draw a line between p0 and p1
          
          p = p1-p0;
          alpha = 0.1;  % Size of arrow head relative to the length of the vector
          beta = 0.1;  % Width of the base of the arrow head relative to the length
          
          hu = [x1-alpha*(p(1)+beta*(p(2)+eps)); x1; x1-alpha*(p(1)-beta*(p(2)+eps))];
          hv = [y1-alpha*(p(2)-beta*(p(1)+eps)); y1; y1-alpha*(p(2)+beta*(p(1)+eps))];
          hw = [z1-alpha*p(3);z1;z1-alpha*p(3)];
          
          hold on
          plot3(hu(:),hv(:),hw(:))  % Plot arrow head
%           grid on
%           xlabel('x')
%           ylabel('y')
%           zlabel('z')
          hold off
      else
          error('p0 and p1 must have the same dimension')
      end
  elseif max(size(p0))==2
      if max(size(p1))==2
          x0 = p0(1);
          y0 = p0(2);
          x1 = p1(1);
          y1 = p1(2);
          x1=x0+scale*(x1-x0);
          y1=y0+scale*(y1-y0);
          % Vertical vecotr
          p0 = [x0;y0];
          p1 = [x1;y1];
          
           %plot([x0;x],[y0;y0+scale*(y1-y0)]);   % Draw a line between p0 and p1
          plot([x0;x1],[y0;y1],col,'LineWidth',linewidth);  
		  e=(p0-p1)/norm(p1-p0)*arrowlength;
		  Mrot=[cosd(arrowangle) -sind(arrowangle)
				sind(arrowangle) cosd(arrowangle)]; 
		  Mrotm=[cosd(-arrowangle) -sind(-arrowangle)
				sind(-arrowangle) cosd(-arrowangle)];		  
		  p2=p1+Mrot*e;
		  p3=p1+Mrotm*e;
          hu = [p2(1); x1; p3(1)];
          hv = [p2(2); y1; p3(2)];
          
          hold on
          plot(hu(:),hv(:),col,'LineWidth',linewidth)  % Plot arrow head
%           grid on
%           xlabel('x')
%           ylabel('y')
          hold on
      else
          error('p0 and p1 must have the same dimension')
      end
  else
      error('this function only accepts 2D or 3D vector')
  end

  
