function [all_length,all_time,all_width,all_lambda,all_avg_lambda,all_lamtime,all_lambda_fit,all_dt,all_finalt,all_startt,all_deltal,all_fluor,all_area,all_fluor_lambda] = collect_data(cs,fluor_on,tshift)
all_length = [];
all_time = [];
all_width = [];
all_lambda = [];
all_avg_lambda = [];
all_lamtime = [];
all_lambda_fit = [];
all_dt = [];
all_finalt = [];
all_startt = [];
all_deltal = [];
all_fluor = [];
all_area = [];
all_fluor_lambda = [];
for i = 1:numel(cs)
    if fluor_on
        all_fluor = [all_fluor cs{i}.avg_fluor];
    end
    all_area = [all_area cs{i}.area];
    all_length = [all_length cs{i}.length];
    all_time = [all_time cs{i}.time+tshift];
    all_width = [all_width cs{i}.width];
    all_lambda = [all_lambda cs{i}.instant_lambda_V];
    try
        all_lambda_fit = [all_lambda_fit cs{i}.lambda.beta(2)];
    catch
        all_lambda_fit = [all_lambda_fit NaN];
    end
    all_avg_lambda = [all_avg_lambda mean(cs{i}.instant_lambda_length)];
    
    all_lamtime = [all_lamtime cs{i}.time(1:end-1)+tshift];
    
    all_dt = [all_dt cs{i}.divtime];
    
    all_finalt = [all_finalt cs{i}.finalt+tshift];
    all_startt = [all_startt cs{i}.startt+tshift];
    
    all_deltal = [all_deltal cs{i}.deltalength];
    
    all_fluor_lambda = [all_fluor_lambda cs{i}.instant_lambda_fluor];
end
end