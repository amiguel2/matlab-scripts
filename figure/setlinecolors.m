function setlinecolors()
h = findobj(gca,'Type','line');
c = cbrewer('qual','Set1',numel(h));
count = 1;
for i = fliplr(1:numel(h))
%     if strcmp(h(i).UserData,'median')
        h(i).Color = c(count,:);
        count = count + 1;
%     end
end
end