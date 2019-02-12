function [m, s] = calc_mean_sem(data)
%     data(isnan(data)) = [];
    Q1 = prctile(data, 25);
    Q3 = prctile(data, 75);
    Qb = Q1 - 3 * (Q3 - Q1);
    Qt = Q3 + 3 * (Q3 - Q1);
    
    data(data < Qb) = [];
    data(data > Qt) = [];
    
    m = mean(data);
    s = std(data) ./ sqrt(length(data) - 1);