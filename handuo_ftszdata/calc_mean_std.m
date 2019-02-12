function [m, s] = calc_mean_std(data)
%     data(isnan(data)) = [];
    m = mean(data);
    s = std(data);