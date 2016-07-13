function plot_chrom_align(color,normtype,peak,peak_t,varargin)
n = numel(varargin);
for i = 1:n
    
   % norm factor
   sample = varargin{i};
   if strcmp(normtype,'max')
       normfactor = max(sample.chrom.final);
   elseif strcmp(normtype,'sum')
       normfactor = sum(sample.chrom.final);
   elseif strcmp(normtype,'none')
       normfactor = 1;
   else
       fprintf('normtype given does not exist. Defualted to none')
       normfactor = 1;%sum(sample.chrom.final);
   end
   
   % shift peak to the same value
   peak_idx = find(strcmp(peak,{sample.Peaks.name}));
   if isempty(peak_idx)
       fprintf('Peak not present\n')
       fprintf('Use: plot_chrom_align(color,normtype,peak,peak_t,var1...)\n')
       return
   end
   pk_start = find(sample.chrom.t > sample.Peaks(peak_idx).interval(1),1);
   pk_end = find(sample.chrom.t > sample.Peaks(peak_idx).interval(2),1);
   pk_tip = find(sample.chrom.final == max(sample.chrom.final(pk_start:pk_end)));
   t = sample.chrom.t - sample.chrom.t(pk_tip) + peak_t;
   plot(t,sample.chrom.final/normfactor,'Color',color(i,:));
   hold on;
end

%text(peak_t,max(sample.chrom.final/normfactor),peak)
end