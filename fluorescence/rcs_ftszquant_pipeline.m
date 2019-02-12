function ftszdata = rcs_ftszquant_pipeline(allfiles,fn,pixel,varargin)

%% calculates

use_fluor_interior = 1; % default = 1
use_1ringonly = 1; % default = 1

if numel(varargin) == 1
    c = varargin{1};
else
    c = cbrewer('qual','Set1',numel(fn));
end

% as of 2018-05-23, using only cells with one ring. Was using all cells
% before. May need to double check other data sets for consistency. 

% files = dir('*CONTOURS.mat');
% files = files([1 9:16 2:8]);
% fn = {'A220','A220p5','A221','A222','A225'};
% allfiles = {};
% allfiles.A220 = files([1 2 7]);
% allfiles.A220p5 = files([1 3 8]);
% allfiles.A221 = files([1 4 9]);
% allfiles.A222 = files([1 5 10]);
% allfiles.A225 = files([1 6 11]);
% fn = fieldnames(allfiles);
% im = imread('../stacks/EM_tp120_fluor.tif',1);
% blank = double(mode(reshape(im,[1,numel(im)])));
% pixel = 0.0652

figure('Color',[1 1 1],'Position',[120 351 1105 289])


ftszdata = struct;
for a = 1:numel(fn)
    all_avefluor = {};
    all_totfluor = {};
    all_length = {};
    all_width = {};
    all_ringfluori = {};
    all_ringfluorc = {};
    all_ringwidth = {};
    all_time = {};

    if isstruct(allfiles)
        eval(sprintf('files = allfiles.%s',fn{a}))
    elseif iscell(allfiles)
        files = allfiles{a};
    end
    for i=1:numel(files)
        if isstruct(files)
        fprintf('%s\n',files(i).name)
        f = load(files(i).name);
        elseif iscell(files)
            f = files{i};
        end
        time = [];
        length = [];
        width = [];
        avefluor = [];
        totfluor = [];
        ringfluorc = [];
        ringfluori = [];
        Rwidth = [];
        for j = 1:numel(f.frame)
            for k = 1:numel(f.frame(j).object)
                ob = f.frame(j).object(k);
                if ~isempty(ob.mesh)
                    if isfield(f.frame(j),'blank')
                    blank = f.frame(j).blank;
                    else
                        blank = double(ob.bkg);
                    end
                    [rFc,rW,rFi] = get_average_ring_intensity(ob,blank,pixel,use_1ringonly);
                    if ~isnan(rFc)
                        ringfluorc = [ringfluorc rFc];
                        ringfluori = [ringfluori rFi];
                        Rwidth = [Rwidth rW];
                    else
                        ringfluorc = [ringfluorc NaN];
                        ringfluori = [ringfluori NaN];
                        Rwidth = [Rwidth NaN];
                    end
                    time = [time (i-1)*30];
                    length = [length ob.cell_length];
                    width = [width ob.cell_width];
                    mesh = ob.mesh;
                    vol = volume_from_mesh(mesh,[mean([mesh(:,1),mesh(:,3)],2), mean([mesh(:,2),mesh(:,4)],2)]);
                    if use_fluor_interior%isfield(ob,'fluor_internal_profile')
                    totfluor = [  totfluor (sum(ob.fluor_internal_profile-blank))];
                    avefluor = [avefluor (sum(ob.fluor_internal_profile-blank))/vol];
                    else
                        totfluor = [  totfluor ob.ave_fluor*ob.area];
                        avefluor = [avefluor ob.ave_fluor];
                    end
                    %
                end
            end
        end
        all_avefluor = [all_avefluor avefluor];
        all_totfluor = [all_totfluor totfluor];
        all_length = [all_length length];
        all_width= [all_width width];
        all_ringfluorc = [all_ringfluorc ringfluorc];
        all_ringfluori = [all_ringfluori ringfluori];
        all_ringwidth = [all_ringwidth Rwidth];
        all_time = [all_time time];
    end
    
    t = nan(numel(all_time),1);
    l = nan(numel(all_time),2);
    w = nan(numel(all_time),2);
    f = nan(numel(all_time),2);
    tf = nan(numel(all_time),2);
    rc = nan(numel(all_time),2);
    ri = nan(numel(all_time),2);
    
    for ab = 1:numel(all_time)
        t(ab) = all_time{ab}(1);
        l(ab,1) = nanmedian(all_length{ab})*pixel;
        l(ab,2) = nanstd(all_length{ab})*pixel/sqrt(numel(~isnan(l)));
        w(ab,1) = nanmedian(all_width{ab})*pixel;
        w(ab,2) = nanstd(all_width{ab})*pixel/sqrt(numel(~isnan(w)));
        f(ab,1) = nanmedian(all_avefluor{ab});
        f(ab,2) = nanstd(all_avefluor{ab})/sqrt(numel(~isnan(f)));
        tf(ab,1) = nanmedian(all_totfluor{ab});
        tf(ab,2) = nanstd(all_totfluor{ab})/sqrt(numel(~isnan(tf)));
        rc(ab,1) = nanmedian(all_ringfluorc{ab});
        rc(ab,2) = nanstd(all_ringfluorc{ab})/sqrt(numel(~isnan(rc)));
        ri(ab,1) = nanmedian(all_ringfluori{ab});
        ri(ab,2) = nanstd(all_ringfluori{ab})/sqrt(numel(~isnan(ri)));
    end
    subplot(2,3,1)
    h = errorbar(t,l(:,1),l(:,2),'Color',c(a,:)); hold on;
    set(get(get(h, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
    scatter(t,l(:,1),100,c(a,:),'filled')
    subplot(2,3,2)
    h = errorbar(t,w(:,1),w(:,2),'Color',c(a,:)); hold on;
    set(get(get(h, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
    scatter(t,w(:,1),100,c(a,:),'filled')
    subplot(2,3,3)
    h = errorbar(t,f(:,1),f(:,2),'Color',c(a,:)); hold on;
    set(get(get(h, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
    scatter(t,f(:,1),100,c(a,:),'filled')
    subplot(2,3,4)
    h = errorbar(t,tf(:,1),tf(:,2),'Color',c(a,:)); hold on;
    set(get(get(h, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
    scatter(t,tf(:,1),100,c(a,:),'filled')
    subplot(2,3,5)
    h = errorbar(t,rc(:,1),rc(:,2),'Color',c(a,:)); hold on;
    set(get(get(h, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
    scatter(t,rc(:,1),100,c(a,:),'filled')
    subplot(2,3,6)
    h = errorbar(t,ri(:,1),ri(:,2),'Color',c(a,:)); hold on;
    set(get(get(h, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
    scatter(t,ri(:,1),100,c(a,:),'filled')

    eval(sprintf('ftszdata.%s.all_length = all_length',fn{a}))
    eval(sprintf('ftszdata.%s.all_avefluor = all_avefluor',fn{a}))
    eval(sprintf('ftszdata.%s.all_totfluor = all_totfluor',fn{a}))
    eval(sprintf('ftszdata.%s.all_ringwidth = all_ringwidth',fn{a}))
    eval(sprintf('ftszdata.%s.all_ringfluorc = all_ringfluorc',fn{a}))
    eval(sprintf('ftszdata.%s.all_ringfluori = all_ringfluori',fn{a}))
    eval(sprintf('ftszdata.%s.all_width = all_width',fn{a}))
    eval(sprintf('ftszdata.%s.all_time = all_time',fn{a}))
end


subplot(2,3,1)
title('Length')
if numel(files) > 1
xlim([0 ((numel(files)-1)*30)+10])
end
prettifyplot
subplot(2,3,2)
title('Width')
if numel(files) > 1
xlim([0 ((numel(files)-1)*30)+10])
end
prettifyplot
subplot(2,3,3)
title('Average Fluorescence')
if numel(files) > 1
xlim([0 ((numel(files)-1)*30)+10])
end
prettifyplot
subplot(2,3,4)
title('Total Fluorescence')
if numel(files) > 1
xlim([0 ((numel(files)-1)*30)+10])
end
prettifyplot
subplot(2,3,6)
title('Ring Intensity')
if numel(files) > 1
xlim([0 ((numel(files)-1)*30)+10])
end
prettifyplot
subplot(2,3,5)
title('Ring Concentration')
if numel(files) > 1
xlim([0 ((numel(files)-1)*30)+10])
end
prettifyplot

end
