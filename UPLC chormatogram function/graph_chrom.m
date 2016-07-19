function graph_chrom(samples,varargin)
% graph_chrom({samp1,{Samp2rep1,Samp2rep2},samp3,...},[optional parameters])
% samples is a cell with different loaded chromanalysis files. You can either load single files or replicates.
% Examples:
% To plot individual files, you would use: graph_chrom({samp1,samp2,samp3})
% To plot replicate files, you would use: graph_chrom({{samp1rep1,sampe2rep2})
% To plot samples and replicates, use: graph_chrom({{samp1rep1,samp2rep2},{samp2rep1,samp2rep2})
%
% OPTIONAL
% you can specify additional parameters in the format function(...,'variable',value)
% Optional parameters: 
% legname, add legends to graph
% display_Values, plots the actual bar values as text
% plot_error, adds standard deviation error bars to plots,
% standard_error, plots standard error rather than SD
% iflog, plots individual component graph on a log scale. 
% Optiona parameter Examples:
% graph_chrom({samp1,{Samp2rep1,Samp2rep2},samp3,...},'legname',[{'legend1','legend2',...}])
% will add legends
% 

% default parameters
    legname = [];
    display_values = 0;
    sep_fig = 0;
    plot_error = 1;
    standard_error= 1;
    iflog = 0;

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

% if numel(varargin) == 1
% 
% elseif numel(varargin) == 2
%     legname = varargin{1};
%     text_on = varargin{2};
%     sep_fig = 0;
%     plot_error = 1;
%     standard_error= 1;
%     iflog = 0;
% elseif numel(varargin) == 3
%     legname = varargin{1};
%     text_on = varargin{2};
%     sep_fig = varargin{3};
%     plot_error = 1;
%     standard_error= 1;
%     iflog = 0;
% elseif numel(varargin) == 4
%     legname = varargin{1};
%     text_on = varargin{2};
%     sep_fig =varargin{3};
%     plot_error = varargin{4};
%     standard_error= 1;
%     iflog = 0;
% elseif numel(varargin) == 5
%     legname = varargin{1};
%     text_on = varargin{2};
%     sep_fig = varargin{3};
%     plot_error = varargin{4};
%     standard_error= varargin{5};
%     iflog = 0;
% elseif numel(varargin) == 6
%     legname = varargin{1};
%     text_on = varargin{2};
%     sep_fig = varargin{3};
%     plot_error = varargin{4};
%     standard_error= varargin{5};
%     iflog = varargin{6};
% else
%     text_on = 0;
%     sep_fig = 0;
%     plot_error = 1;
%     standard_error= 1;
% end

if sep_fig
    f1 = figure('Color',[1 1 1],'Position',[100 500 1352 649]);
    f2 = figure('Color',[1 1 1],'Position',[100 0 1352 649]);
else
    figure('Color',[1 1 1],'Position', [100, 100, 1352, 649]);
end

try
    name = extractfield(samples{1}.Peaks,'name');
catch
    name = extractfield(samples{1}{1}.Peaks,'name');
end

mol_frac = [];
try
    pgquant_name = {samples{1}.calculations{:,1}};
catch
    pgquant_name = {samples{1}{1}.calculations{:,1}};
end
pgquant = [];
smerror = [];
sperror = [];
for i = 1:numel(samples)
    sample = samples{i};
    if isstruct(sample)
        m = extractfield(sample.Peaks,'mol_frac');
        pgq = [sample.calculations{:,3}];
        mol_frac = [mol_frac; m];
        pgquant = [pgquant; pgq];
        smerror = [smerror; NaN(1,numel(m))];
        sperror = [sperror; NaN(1,numel(pgq))];
    elseif iscell(sample)
        [a,m,pgq,sa,sm,spgq] = average_replicates(sample,standard_error);
        mol_frac = [mol_frac; m];
        pgquant = [pgquant; pgq];
        smerror = [smerror; sm];
        sperror = [sperror; spgq];
        
    end
end
if sep_fig
    figure(f1)
else
    subplot(2,1,1)
end
hb = bar(1:numel(name),mol_frac');
% For each set of bars, find the centers of the bars, and write error bars

pause(0.1); %pause allows the figure to be created
for ib = 1:numel(hb)
    %XData property is the tick labels/group centers; XOffset is the offset
    %of each distinct group
    xData = hb(ib).XData+hb(ib).XOffset;
    if plot_error
        hold on;errorbar(xData,mol_frac(ib,:),smerror(ib,:),'.r','Color','red')
    end
    fun = @(x) sprintf('%0.4f', x);
    D = cellfun(fun, num2cell(mol_frac(ib,:)), 'UniformOutput',0);
    if display_values && ~iflog
        hold on; text(hb(1).XData+hb(1).XOffset,(ones(1,numel(xData))*(-.1))+(.025*(1-ib)),D);
    elseif display_values && iflog
        hold on;text(hb(1).XData+hb(1).XOffset,(ones(1,numel(xData))*(0.00003))+(0.00001*(1-ib)),D);
    end
end


% hold on;errorbar(xlabels,mol_frac',smerror','.r','Color','red');
set(gca,'XTick',[1:numel(name)])
set(gca,'XTickLabel',name)
if numel(varargin) > 0
    legend(legname)
end

if iflog
    set(gca,'yscale','log');
end
title('Muropeptide Quantities')
xlim([0 26])
if sep_fig
    figure(f2);
else
    subplot(2,1,2)
end
hb1 = bar(1:numel(pgquant_name),pgquant');

pause(0.1); %pause allows the figure to be created
for ib = 1:numel(hb1)
    %XData property is the tick labels/group centers; XOffset is the offset
    %of each distinct group
    if sep_fig
        figure(f2);
    else
        subplot(2,1,2)
    end
    xData = hb1(ib).XData+hb1(ib).XOffset;
    if plot_error
        hold on;errorbar(xData,pgquant(ib,:),sperror(ib,:),'.r','Color','red')
    end
    fun = @(x) sprintf('%0.1f', x);
    D = cellfun(fun, num2cell(pgquant(ib,:)), 'UniformOutput',0);
    if display_values
        hold on;text(hb1(1).XData+hb1(1).XOffset,(ones(1,numel(xData))*(-10))+(3*(1-ib)),D);
    end
end

%hold on;errorbar(repmat(1:numel(pgquant_name),numel(samples),1)',pgquant',sperror','.r','Color','red');
set(gca,'XTick',[1:numel(pgquant_name)])
set(gca,'XTickLabel',pgquant_name)
if numel(varargin) > 0
    legend(legname)
end
title('PG Quantitation')
end

function [avg_area, avg_molfrac, avg_pgq,ste_area, ste_molfrac, ste_pgq] = average_replicates(samples,standard_error)
parea = [];
mol_frac = [];
pgquant = [];

for sample = samples
    parea = [parea; extractfield(sample{1}.Peaks,'area')];
    mol_frac = [mol_frac; extractfield(sample{1}.Peaks,'mol_frac')];
    pgquant = [pgquant; [sample{1}.calculations{:,3}]];
end

avg_area = mean(parea);
avg_molfrac = mean(mol_frac);
avg_pgq = mean(pgquant);

if standard_error
    ste_area = std(parea)/numel(samples);
    ste_molfrac = std(mol_frac)/numel(samples);
    ste_pgq = std(pgquant)/numel(samples);
else
    ste_area = std(parea);
    ste_molfrac = std(mol_frac);
    ste_pgq = std(pgquant);
end

end