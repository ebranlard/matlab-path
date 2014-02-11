

% figure(1)
% clf
% h3 = polar([0 2*pi], [0 1],'');
% axis  off
% ph=findall(gca,'type','text');
% ps=get(ph,'string');
% disp([num2cell(1:numel(ps)).',ps]);
% ps(:)={''};
% ps([4 5 10 11])={'90','270','180','0'};
% set(ph,{'string'},ps);
% delete(h3)
% ps=get(ph,'fontweight');
% ps(:)={'bold'};
% set(ph,{'fontweight'},ps);
%
hold on
% contourf(Xplane/R,Yplane/R,WI{1},40,'LineStyle','none')
%[C,h] = contourf(Yplane/R,Xplane/R,WI{1},40,'LineStyle','none');
[C,h] = contourf(Yplane/R,Xplane/R,WI{1},24,'Color','k');
text_handle = clabel(C,h,'labelspacing',120,'rotation',0);
%t = clabel(cs,h,'labelspacing',72);
%clabel('contour handle','manual','fontsize',6,'rotation',0,'Color',[0 0.5 0], 'fontname','Arial Narrow' , 'fontweight', 'bold' ) ;

%
Pos=get(text_handle(:),'Position');
Pos=cell2mat(Pos);
Pos=Pos(:,1:2);
%
n=length(Pos(:,1));
Iremoved=[];
I=1:n;
for i=1:n
    x=Pos(i,:);
    Pos2=Pos;
    Pos2(i,:)=[100 100];
    Ml=sqrt((Pos2(:,1)-x(1)).^2+(Pos2(:,2)-x(2)).^2);
    Iremoved=[Iremoved I(Ml<0.05)];
end
Iremoved=unique(Iremoved);
Ikept=setdiff(I,Iremoved);

% figure
% hold all
% plot(Pos(Iremoved,1),Pos(Iremoved,2),'r+')
% plot(Pos(Ikept,1),Pos(Ikept,2),'b+')

%
for k = 1:length(Ikept)
    thelabel = str2num(get(text_handle(Ikept(k)), 'String'));
    set(text_handle(Ikept(k)), 'String', sprintf('%2.2f', thelabel));
end
for k = 1:length(Iremoved)
    thelabel = str2num(get(text_handle(Iremoved(k)), 'String'));
    set(text_handle(Iremoved(k)), 'String', '');
end


setFigureWidth('14')
% 
% 
% set(text_handle,'BackgroundColor',[1 1 .6],'Edgecolor',[.7 .7 .7])
axis equal
% colormap('gray'); caxis([-3 3])
%colorbar
set(gcf,'Colormap',mycmap); caxis([-2.5 3.5])

title('ValidationNRELAzimuthz0')

