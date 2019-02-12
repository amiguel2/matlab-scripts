function plot_odgrowthrate_96well(logod,time,varargin)
blanks = varargin{1};
for i = 1:96
        h = subplot(8,12,i);
        if find(i == blanks)
        h.Color = [0.5 0.5 0.5];
        else
        plot(time,logod(:,i))
         ylim([0 1.5]);
        end
end
end