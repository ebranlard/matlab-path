function [ output_args ] = fplotDegrad( x,y,ic )
% ic is 1,2,3
n=length(x);
Colrs=zeros(n,3);
Colrs(:,ic)=linspace(0,1,n);
%set(0,'DefaultAxesColorOrder',Colrs)
fprintf('fplotDegrad: black is start, full color is end\n')

vSty={'ko','kd','kx'};
hold all
plot(x(1),y(1),vSty{ic},'MarkerSize',9);
for i =2:(n-1)
    plot(x(i),y(i),'+','MarkerEdgeColor',Colrs(i,:))
end
plot(x(n),y(n),'.','MarkerEdgeColor',Colrs(i,:),'MarkerSize',6)
% plot(x,y,'-')
%plot(x,y,'+','MarkerEdgeColor',Colrs)
%set(0,'DefaultAxesColorOrder','remove')
