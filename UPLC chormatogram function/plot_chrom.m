function plot_chrom(samples,varargin)

% plot_chrom(samples,[optional parameters])
% samples is a cell with different loaded chromanalysis files.
% Example: graph_chrom({samp1,samp2,samp3})
%
% OPTIONAL
% you can specify additional parameters in the format function(...,'variable',value)
% Optional parameters: color,shift,align,avg_on
% 
% 'color', changes color of plot
% 'normtype', performs normalization on chromatogram. three types: 'none','max','sum'
% 'shift', shifts chromatogram on Y-axis
% 'align_param', aligns to certain peak. Requires align_param in the format: {'Peak Name', 'X-axis position'}. Ex. {'D44',12}
% 'avg_on', plots the average of all samples
%
% Optional parameter Examples:
% plot_chrom({KC664,KC665,KC666},'normtype','sum','color',[1 0 0; 0 1 0;0 0 1]); 
% - will plot three chromatograms with specified colors using sum normalization




%% default variables
color = cbrewer('qual','Set1',numel(samples));
shift = 0;
avg_on = 0;
normtype = 'none';
label=0;

if ~isempty(varargin)
    evennumvars = mod(numel(varargin),2);
    if evennumvars
        fprintf('Too many arguments. Use: plot_chrom({samples},[optional] normtype shift align_param avg_on color)\n')
        return
    end
    
    for i = 1:2:numel(varargin)
        eval(sprintf('%s = varargin{%d};',varargin{i},i+1));
    end
end

% if align specified, plot aligned
if exist('align_param','var')
    plot_chrom_align(samples,normtype,align_param{1},align_param{2},shift,color,label)
else
    % estimate array size
    array_size = cellfun(@(x) numel(x.t), extractfield(cellfun(@(x) x,samples),'chrom'));

    % for each sample
    for i = 1:numel(samples)
        sample = samples{i};
        if exist('normtype','var')
            normfactor = specify_norm(sample,normtype);
        end
        % initialize arrays
        f = zeros(min(array_size),1);
        t = zeros(min(array_size),1);
        
        % normalize chrom based on specified norm type
        fn = sample.chrom.final/normfactor;
        % shift y-axis by specified increment
        f = f + fn(1:numel(f))+(shift*(i-1));
        % get x-axis values
        t = t + sample.chrom.t(1:numel(t));
        % plot chromatogram
        plot(t,f,'Color',color(i,:));
        hold on;
        if label && i == numel(samples)
            plot_labels(sample,shift)
        end
        
        text(-1,shift*(i-1),sprintf('(%d)',i),'Color',color(i,:))
        
    end
    if avg_on %if avg_on, plot average of all samples
        plot(t/n,f/n,'Color','Black','LineStyle',':');
    end
    xlim([0 22])
    hold off;
end
end

% function that specifies the factor based on normtype
function normfactor = specify_norm(sample,normtype)
if strcmp(normtype,'max')
    normfactor = max(sample.chrom.final);
elseif strcmp(normtype,'sum')
    normfactor = sum(sample.chrom.final);
elseif strcmp(normtype,'none')
    normfactor = 1;
else
    fprintf('normtype given does not exist. Defaulted to none')
    normfactor = 1;
end
end

% function that plots aligned peaks
function plot_chrom_align(samples,normtype,peak,peak_t,shift,color,label)
% estimate array size
array_size = cellfun(@(x) numel(x.t), extractfield(cellfun(@(x) x,samples),'chrom'));

for i = 1:numel(samples)
    % initilize arrays
    f = zeros(min(array_size),1);
    t = zeros(min(array_size),1);
    sample = samples{i};
    % find peak
    peak_idx = find(strcmp(peak,{sample.Peaks.name}));
    if isempty(peak_idx)
        fprintf('Peak not present\n')
        return
    end
    % get peak start, end, and peak values
    pk_start = find(sample.chrom.t > sample.Peaks(peak_idx).interval(1),1);
    pk_end = find(sample.chrom.t > sample.Peaks(peak_idx).interval(2),1);
    pk_tip = find(sample.chrom.final == max(sample.chrom.final(pk_start:pk_end)));
    
    % properly normalize
    normfactor = specify_norm(sample,normtype);
    fn = sample.chrom.final/normfactor;
    % shift Y-axis if specified
    f = f + fn(1:numel(f))+(shift*(i-1));
    % shift X-axis to specified position peak_t
    t = t + sample.chrom.t(1:numel(t)) - sample.chrom.t(pk_tip) + peak_t;
    % plot shifted values
    plot(t,f,'Color',color(i,:));
    hold on;
    
    if label && i == numel(samples)
        plot_labels(sample,shift)
    end
end

end

 function plot_labels(sample,shift)
    for peak_idx = 1:numel(sample.Peaks)
        % get peak start, end, and peak values
        pk_start = find(sample.chrom.t > sample.Peaks(peak_idx).interval(1),1);
        pk_end = find(sample.chrom.t > sample.Peaks(peak_idx).interval(2),1);
        pk_tip = find(sample.chrom.final == max(sample.chrom.final(pk_start:pk_end)));
        x = sample.chrom.t(pk_start);
        y = -0.05;
        w = sample.chrom.t(pk_end)-sample.chrom.t(pk_start);
        h = 0.01;
        if mod(peak_idx,2) == 0
            rectangle('Position',[x,y,w,h],'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);
            text(sample.chrom.t(pk_tip),0.05+sample.chrom.final(pk_tip)+shift,sample.Peaks(peak_idx).name,'Color',[0 0 0])
        else
            rectangle('Position',[x,y,w,h],'FaceColor',[0 0 1],'EdgeColor',[0 0 1]);
            text(sample.chrom.t(pk_tip),0.05+sample.chrom.final(pk_tip)+shift,sample.Peaks(peak_idx).name,'Color',[0 0 1])
        end
        
    end
 end
