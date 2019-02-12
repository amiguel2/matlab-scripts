function p = plotlindatafit_cellwidth(data1,data2)
    idx = ~isnan(data1) & ~isnan(data2);
    p = polyfit(data1(idx),data2(idx),1);
    x = linspace(0,2,100);
    plot(x,polyval(p,x))
end