function clabel_clean(text_handle,threshold)
    % function that purges a bit the clabel of a matlab contour plot based on a distance threshold between labels


% text_handle = clabel(C,h,'labelspacing',120);


% %t = clabel(cs,h,'labelspacing',72);
% %clabel('contour handle','manual','fontsize',6,'rotation',0,'Color',[0 0.5 0], 'fontname','Arial Narrow' , 'fontweight', 'bold' ) ;
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
    Iremoved=[Iremoved I(Ml<threshold)];
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

for k = 1:numel(text_handle)
    thelabel = str2num(get(text_handle(k), 'String'));
%     if(thelabel<0)
%         set(text_handle(k), 'String', sprintf('%2.2f', thelabel),'Color','w');
%     else
         set(text_handle(k), 'String', sprintf('%2.2f', thelabel));
%     end
end

