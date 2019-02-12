function prettifyplot(position)
fig = gcf;
if exist('position')
    fig.Position = position;
else
    %set(fig,'units','normalized','outerposition',[0 0 2/3 1])
%      fig.Position = [25 25 325 325];
%       fig.Position = [0 0 300 300];
end
% font sizes
set(gca,'FontSize',15)
set(gca,'FontName','Myriad Pro')
h=get(gca,'xlabel');
set(h, 'FontSize', 20) 
h=get(gca,'ylabel');
set(h, 'FontSize', 20)
h=get(gca,'title');
set(h, 'FontSize', 20)
set(gcf,'color','white')
% a=findobj(gca,'type','axe');
% set(get(a,'ylabel'), 'Units', 'Normalized', 'Position', [-0.06, 0.5, 0]);
% set(get(a,'xlabel'), 'Units', 'Normalized', 'Position', [0.5,-0.07, 0]);

% plotted text
h = findobj(gca,'Type','text')
set(h, 'FontSize', 15) 

% plot lines
% h = findobj(gca,'Type','line');
% set(h, 'LineWidth',2)
% 
% scatter 
% h = findobj(gca,'Type','Scatter');
% set(h, 'SizeData',100)

% numberOfXTicks = 5;
% set(gca,'Xtick',linspace(0,100,numberOfXTicks))
end