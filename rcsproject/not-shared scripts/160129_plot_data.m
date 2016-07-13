list = dir('peri*.mat');

all_length = [];
all_time = [];
all_deltalength = [];
all_avg_lambda = [];
all_lambda_t = [];
all_cid = [];
finalt = [];
cellmarkers = [];

for i = 1:numel(list)
    f = load(list(i).name);
    f = make_celltable(f);
    [l,t,dt,lam,lamt,cid,ft,st,cm] = plot_data(f,4,0.08,0);
    close all
    all_length = [all_length l];
    all_time = [all_time t];
    all_deltalength = [all_deltalength dt];
    all_avg_lambda = [all_avg_lambda lam];
    all_lambda_t = [all_lambda_t lamt];
    all_cid = [all_cid cid];
    finalt = [finalt];
    cellmarkers = [cellmarkers cm];
end

plot_combined_data