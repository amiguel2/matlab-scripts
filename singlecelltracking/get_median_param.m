function [med_param,err_param] = get_median_param(all_param,all_t)
    med_param = [];
    err_param = [];
    for i = 1:max(all_t)
        idx = find(i == all_t);
        med_param = [med_param;[i,nanmedian(all_param(idx))]];
        err_param = [err_param; [i,nanstd(all_param(idx))]];
    end
end