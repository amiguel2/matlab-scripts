function plot_chrom(samples,varargin)
% plot_chrom({sample 1, sample2,...},[normtype],[shift],[avg_on],[color],[align_param])
% normtype options: 'none','max','sum'

% default variables
color = cbrewer('qual','Set1',numel(samples));
shift = 0;
avg_on = 0;
normtype = 'none';

if ~isempty(varargin)
    evennumvars = mod(numel(varargin),2);
    if evennumvars
        fprintf('Too many arguments. Use: get_data(list,tframe,pxl,[optional] fluor lineage tshift microbej onecolor)\n')
        return
    end
    
    for i = 1:2:numel(varargin)
        eval(sprintf('%s = varargin{%d};',varargin{i},i+1));
    end
end

% % optional variables
% n = numel(varargin); % number of variables
% if n == 0 || n == 1
%     %default parameters
% 
% elseif n == 2
%     shift = varargin{2};
%     [align,align_param] = call_align_param(align);
% elseif n == 3
%     shift = varargin{2};
%     avg_on = varargin{3};
%     [align,align_param] = call_align_param(align);
% elseif n == 4
%     shift = varargin{2};
%     avg_on = varargin{3};
%     color = varargin{4};
%     if size(color) ~= [numel(samples),3]
%         fprintf('Color not correct dimensions. Setting default color')
%     end
%     [align,align_param] = call_align_param(align);
% elseif n == 5
%     shift = varargin{2};
%     avg_on = varargin{3};
%     color = varargin{4};
%     if size(color) ~= [numel(samples),3]
%         fprintf('Color not correct dimensions. Setting default color')
%     end
%     align = 1;
%     align_param = varargin{5};
% else
%     fprint('Too many variables\nplot_chrom({sample 1, sample2,...},[normtype],[shift],[avg_on],[color])\n')
% end

if exist('align_param','var')
    %[align_param] = call_align_param(align);
    plot_chrom_align(samples,normtype,align_param{1},align_param{2},shift,color)
else
    % estimate array size
    array_size = cellfun(@(x) numel(x.t), extractfield(cellfun(@(x) x,samples),'chrom'));
    f = zeros(min(array_size),1);
    t = zeros(min(array_size),1);
    for i = 1:numel(samples)
        sample = samples{i};
        if exist('normtype','var')
            normfactor = specify_norm(sample,normtype);
        end
        fn = sample.chrom.final/normfactor;
        f = f + fn(1:numel(f));
        t = t + sample.chrom.t(1:numel(t));
        plot(sample.chrom.t,(sample.chrom.final/normfactor)+(shift*(i-1)),'Color',color(i,:));
        hold on;
    end
    if avg_on
        plot(t/n,f/n,'Color','Black','LineStyle',':');
    end
    xlim([0 22])
    hold off;
end
end

function normfactor = specify_norm(sample,normtype)
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
end

function plot_chrom_align(samples,normtype,peak,peak_t,shift,color)
% estimate array size
array_size = cellfun(@(x) numel(x.t), extractfield(cellfun(@(x) x,samples),'chrom'));

for i = 1:numel(samples)
    f = zeros(min(array_size),1);
    t = zeros(min(array_size),1);
    sample = samples{i};
    peak_idx = find(strcmp(peak,{sample.Peaks.name}));
    if isempty(peak_idx)
        fprintf('Peak not present\n')
        return
    end
    pk_start = find(sample.chrom.t > sample.Peaks(peak_idx).interval(1),1);
    pk_end = find(sample.chrom.t > sample.Peaks(peak_idx).interval(2),1);
    pk_tip = find(sample.chrom.final == max(sample.chrom.final(pk_start:pk_end)));
    
    normfactor = specify_norm(sample,normtype);
    fn = sample.chrom.final/normfactor;
    f = f + fn(1:numel(f))+(shift*(i-1));
    t = t + sample.chrom.t(1:numel(t)) - sample.chrom.t(pk_tip) + peak_t;
    
    plot(t,f,'Color',color(i,:));
    hold on;
end
end

function [ap] = call_align_param(a)
ap = [];
% while isempty(a)
%     a = input('Align? 1 for yes, 0 for no\n');
% end
% if a
ap{1} = input('What peak? Ex. ''D44''\n','s');
ap{2} = input('What peak shift (along the x axis)? Ex. 5\n');
% end

end