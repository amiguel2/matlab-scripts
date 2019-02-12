function setlinecolors()
h = findobj(gca,'Type','line');
c = cbrewer('qual','Set1',numel(h));
for i = 1:numel(h)
    h(i).Color = c(i,:);
end
end