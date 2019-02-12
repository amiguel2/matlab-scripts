function [r,r2,p] = calcCorr(data1,data2)
    idx = ~isnan(data1) & ~isnan(data2);
    [R,P] = corrcoef(data1(idx),data2(idx));
    r = R(1,2);
    p = P(1,2);
    r2 = r^2;
end