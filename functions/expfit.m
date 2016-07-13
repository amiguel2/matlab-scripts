function yhat = expfit(beta,x)
yhat = beta(1)*exp(x*beta(2));
end