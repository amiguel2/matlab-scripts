function plot_chrom_avg(color,normtype,varargin)
n = numel(varargin);
f = zeros(numel(varargin{2}.chrom.t),1);
t = zeros(numel(varargin{2}.chrom.t),1);
for i = 1:n
   sample = varargin{i};
   if strcmp(normtype,'max')
       normfactor = max(sample.chrom.final);
   elseif strcmp(normtype,'sum')
       normfactor = sum(sample.chrom.final);
   elseif strcmp(normtype,'none')
       normfactor = 1;
   else
       fprintf('normtype given does not exist. Defaulted to none')
       normfactor = 1;%sum(sample.chrom.final);
   end
   fn = sample.chrom.final/normfactor;
   f = f + fn(1:numel(f));
   t = t + sample.chrom.t(1:numel(t));
   plot(sample.chrom.t,sample.chrom.final/normfactor,'Color',color(i,:));
   hold on;
end
plot(t/n,f/n,'Color','Black','LineStyle',':');
xlim([0 22])
end