function [fitresult,gof] = fitGompertzModel(time,logOD)

%% define gompertz equation
% this is the modified form of gompertz from Zweitering et al. (1990)
% gompertz = @(OD_sat,OD_0,lambda,mu,time) ...
%     log(OD_0)+log(OD_sat/OD_0)*exp(-exp(mu*exp(1)./log(OD_sat/OD_0).*(lambda-time)+1));

%{
    OD_0 is the initial OD
    OD_sat is the saturation level
    lambda is the lag time
    mu is the growth rate
%}    

%% set fit type
ft = fittype('log(OD_0)+log(OD_sat/OD_0)*exp(-exp(mu*exp(1)./log(OD_sat/OD_0).*(lambda-time)+1))', ...
    'dependent', {'logOD'}, ...
    'independent', {'time'}, ...
    'coefficients',{'OD_sat','OD_0','lambda','mu'});
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );

%% set bounds
%               OD_sat                OD_0              lambda       mu
opts.Lower = [  realmin               realmin           0         realmin];
opts.Upper = [  1.1*exp(max(logOD))  exp(max(logOD))   max(time) .1     ];
% when OD_max is set too high, can hit bound
% due to function definition, need to limit ODs >0

%% set start points
opts.StartPoint = [exp(max(logOD)) exp(min(logOD)) realmin 1/max(time)];


[fitresult, gof] = fit(time, logOD, ft, opts);


