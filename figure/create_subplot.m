function [f,ax]= create_subplot(n,m)
f = figure('Color',[1 1 1]);
ax = zeros(n*m,1);
for i = 1:(n*m)
    ax(i)=subplot(n,m,i);
end
end