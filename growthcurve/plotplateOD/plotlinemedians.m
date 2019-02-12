function plotlinemedians()
h = findobj(gca,'Type','line');

N = numel(h);
M = numel(h(1).YData);
Ydata = zeros(N,M)
Xdata = h(1).XData;
for i = 1:numel(h)
    Ydata(i,:) = h(i).YData;
    h(i).Color = [0.8 0.8 0.8]
end
plot(Xdata,mean(Ydata),'LineWidth',2)
end