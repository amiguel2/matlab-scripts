function  y = nanmean2(x)
y = mean(x(~isnan(x)));
end