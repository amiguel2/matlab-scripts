function yhat = powerfit(beta,x)

yhat = beta(1)*power(2,x/beta(2));