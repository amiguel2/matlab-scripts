
clear; close all;
cd '/Volumes/Amanda_Port/2018-12-20_A22_timelapse_cellasic_dh300wt_rprA/timelapse_A22_3/stacks'
list1 = dir('*1-*28-Dec-2018_CONTOURS.mat'); %
list2 = dir('*2-*28-Dec-2018_CONTOURS.mat'); %
list3 = dir('*3-*28-Dec-2018_CONTOURS.mat'); %
list4 = dir('*4-*28-Dec-2018_CONTOURS.mat'); %
c = cbrewer('qual','Set1',6);
pixelratio = 0.08;

% differences between deepcell and morphometrics are present due to hand
% contouring, which makes cells a little wider. to account for this, I analyzed using morph and feature
% stacks on the same first frames and took the ratio between deepcell and
% morph analysis to correct for:
[l,w]= averages_of_stack('*CONTOURS_ROC.mat');

%** OUTPUT **

% 1-Pos_feature_firstframes_31-Dec-2018_CONTOURS_ROC.mat: 5.687810 1.396770
% 1-Pos_firstframes_31-Dec-2018_CONTOURS_ROC.mat: 5.963307 1.194439
% 2-Pos_feature_firstframes_31-Dec-2018_CONTOURS_ROC.mat: 6.938597 1.384767
% 2-Pos_firstframes_31-Dec-2018_CONTOURS_ROC.mat: 6.372080 1.190519
% 3-Pos_feature_firstframes_31-Dec-2018_CONTOURS_ROC.mat: 5.689406 1.387325
% 3-Pos_firstframes_31-Dec-2018_CONTOURS_ROC.mat: 5.983591 1.179533
% 4-Pos_feature_firstframes_31-Dec-2018_CONTOURS_ROC.mat: 6.311343 1.402741
% 4-Pos_firstframes_31-Dec-2018_CONTOURS_ROC.mat: 6.393493 1.193195

deepcell_to_morphlaplacian_ratio = mean(w([2:2:8])./w([1:2:8]));
mut1 = get_data(list1,2,pixelratio*deepcell_to_morphlaplacian_ratio,'onecolor',[ 0 0 0]);
mut2 = get_data(list2,2,pixelratio*deepcell_to_morphlaplacian_ratio,'onecolor',c(6,:));
mut3 = get_data(list3,2,pixelratio*deepcell_to_morphlaplacian_ratio,'onecolor',c(5,:));
mut4 = get_data(list4,2,pixelratio*deepcell_to_morphlaplacian_ratio,'onecolor',c(1,:));
%%

for i = 1:numel(mut1)
    mut1{i}.norm_avg_fluor = mut1{i}.avg_fluor/mut1{i}.avg_fluor(1);
end
for i = 1:numel(mut2)
    mut2{i}.norm_avg_fluor = mut2{i}.avg_fluor/mut2{i}.avg_fluor(1);
end
for i = 1:numel(mut3)
    mut3{i}.norm_avg_fluor = mut3{i}.avg_fluor/mut3{i}.avg_fluor(1);
end
for i = 1:numel(mut4)
    mut4{i}.norm_avg_fluor = mut4{i}.avg_fluor/mut4{i}.avg_fluor(1);
end


%% Median Comparisons
exp = {mut1,mut3,mut4}
expname = {'A22_0','A22_2','A22_5'};
tS = 0;
tF = 60;
lineage_on = 0;
fluor_on = 1;
mediandata = plot_median_data(exp,expname,tS,tF,lineage_on,fluor_on,'induction_switch',0);
legend('0','2','5')
% saveplots('AM_IM228_medcomp_fluor')

%%
%% Median Comparisons
exp = {mut1,mut2,mut3,mut4}
expname = {'A22_0','A22_1','A22_2','A22_5'};
tS = 0;
tF = 60;
lineage_on = 0;
fluor_on = 1;
mediandata = plot_median_data(exp,expname,tS,tF,lineage_on,fluor_on,'induction_switch',0);
legend('0','1','2','5')
% saveplots('AM_IM228_medcomp_normfluor')


%% Single Cell plots
close
tF = 60;
tS = 0;
cs=exp{4};
histc = cbrewer('seq','Reds',76); histc = histc(12:end,:);
plot_singlecell_data(cs,c(1,:),tF,tS,histc,'induction_switch',0,'fluor_on',1);
% saveplots('IM-IPTG')
% close
% tF = 120;
% tS = 0;
% cs=exp{2};
% histc = cbrewer('seq','Reds',76); histc = histc(12:end,:);
% plot_singlecell_data(cs,c(1,:),tF,tS,histc,'induction_switch',30);
% % saveplots('IM-A22IPTG')
% close

%%
colors = [0 0 0; c(5,:);c(1,:)];

for i = 1:numel(exp)
    mut = exp{i};
    neww = {};
    newflr = {};
    count = 0;
    for t = [0 30 60]
        count = count + 1;
        w = [];
        flr = [];
        for j = 1:numel(mut)
            idx = find(mut{j}.time == t);
            w = [w mut{j}.width(idx)];
            flr = [flr mut{j}.tot_fluor(idx)];
        end
        neww = [neww w(~isnan(w) & ~isnan(flr))];
        newflr = [newflr flr(~isnan(w) & ~isnan(flr))];
        if count == 1
            scatter(mean(neww{count}),mean(newflr{count}),200,colors(i,:)); hold on;
        else
            scatter(mean(neww{count}),mean(newflr{count}),200,colors(i,:),'filled'); hold on;
            plot([mean(neww{count-1}) mean(neww{count})],[ mean(newflr{count-1}) mean(newflr{count})],'Color',colors(i,:),'LineStyle','--')
        end
        errorbar(mean(neww{count}),mean(newflr{count}),std(newflr{count}),'Color',colors(i,:))
        h = herrorbar(mean(neww{count}),mean(newflr{count}),std(neww{count}));
        h(1).Color = colors(i,:);
        h(2).Color = colors(i,:);
    end
end

prettifyplot
xlabel('Width (µm)')
ylabel('Total Fluorescence (A.U)')
print(gcf, '-dpdf','FvWt0_30_60m')


