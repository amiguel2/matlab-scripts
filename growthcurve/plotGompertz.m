function y = plotGompertz(fitresult,time)
OD_0 = fitresult.OD_0;
OD_sat = fitresult.OD_sat;
mu = fitresult.mu(1);
lambda = fitresult.lambda(1);
y = log(OD_0)+log(OD_sat/OD_0)*exp(-exp(mu*exp(1)./log(OD_sat/OD_0).*(lambda-time)+1));
end