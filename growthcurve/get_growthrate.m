function [srate,vargout] = get_growthrate(logod,time)
temptime = repmat(time,[1,size(logod,2)]);
rate = diff(logod)./diff(temptime);
rate(isinf(rate)) = NaN;
for i = 1:size(logod,2)
srate(:,i) = smooth(rate(:,i),10);
end
vargout{1} = max(srate);
end