% close all;
c = cbrewer('qual','Set1',30);
leg = {};
for i = 1:6
    plotpositions(sprintf('%d-Pos_001_000/metadata.txt',i),c(i,:)); hold on
    leg = [leg sprintf('%s',num2str(i))];
end
legend(leg)