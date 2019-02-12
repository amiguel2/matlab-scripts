function plotlinemedians()
h = findobj(gca,'Type','line');

N = numel(h);
M = numel(h(1).YData);
Ydata = nan(N,M);
Xdata = h(1).XData;
for i = 1:numel(h)
    if ~strcmp(h(i).UserData,'rep') & ~strcmp(h(i).UserData,'median')
        Ydata(i,:) = h(i).YData;
        h(i).Color = [0.8 0.8 0.8];
        h(i).UserData = 'rep';
        set(get(get(h(i),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    end
end
plot(Xdata,nanmean(Ydata),'LineWidth',2,'UserData','median')
end