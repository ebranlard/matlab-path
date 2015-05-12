function [ col ] = fColorGrad( x )
% x between -1 and 1
% -1 : red
% 0 : white
% 1 : blue
% col=interp1([-1 -0.5 0 0.5 1],[fColrs(2); fColrs(6); 1 1 1;fColrs(5);fColrs(1)],x);
col=interp1([-1 0  1],[fColrs(2); fColrs(5);fColrs(1)],x);
end


%%
% x=linspace(-1,1,50);
% colrs=interp1([-1 -0.5 0 0.5 1],[fColrs(2); fColrs(6); 1 1 1;fColrs(5);fColrs(1)],x);
% figure
% hold all
% for i=1:length(x)
%     plot(x(i),x(i),'s','MarkerFaceColor',colrs(i,:),'Color',colrs(i,:))
% end
% x=linspace(-1,1,50);
% colrs=interp1([-1 0  1],[fColrs(2); fColrs(5);fColrs(1)],x);
% figure
% hold all
% for i=1:length(x)
%     plot(x(i),x(i),'s','MarkerFaceColor',colrs(i,:),'Color',colrs(i,:))
% end
