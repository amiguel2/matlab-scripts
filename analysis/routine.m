%% 
mesh_all_folders

%%
Analyze_meshes

%%
[cell_width,cell_length] = widthanalysis('20-Dec-2012_ecolib_ceph_nutritional_shift_exp30_tritc_3_standard.mat',0,120);

%%
woldringh_prepcode
figure(2)
hold on;
scatter(1:120,timelapse_mw_r,'green')
LM = LinearModel.fit(1:20,timelapse_mw_r(1,1:120))
plot(LM)

% scatter(1:30,time0,'green')
% scatter(31:60,time30,'green')
% scatter(61:90,time60,'green')
% scatter(91:120,time90,'green')
% scatter(121:150,time120,'green')
% scatter(151:180,time150,'green')
% 
% LM = LinearModel.fit(31:60,time30)
% plot(LM)
% LM = LinearModel.fit(61:90,time60)
% plot(LM)
% LM = LinearModel.fit(1:30,time0)
% plot(LM)
% LM = LinearModel.fit(91:120,time90)
% plot(LM)
% LM = LinearModel.fit(121:150,time120)
% plot(LM)
% LM = LinearModel.fit(151:180,time150)
% plot(LM)


%%
hold on;
for i= 1:size(time,1)
scatter(151:180,time(i,:),'red')
end


%%
width = NaN(1,length(frame(1,1).object));
length_ecoli = NaN(1,length(frame(1,1).object));
for i = 1:length(frame(1,1).object)
    if frame(1,1).object(1,i).on_edge ~= 1
        if frame(1,1).object(1,i).MT_width < 15 && frame(1,1).object(1,i).MT_width > 6
        width(i) = frame(1,1).object(1,i).MT_width;
        end
        length_ecoli(i) = frame(1,1).object(1,i).MT_length;
    end
end
nanmean(width*.08)
nanmean(length_ecoli*.08)
max(width*.08)
min(width*.08)

%%

% [time0_width,time0_length] = widthanalysis('19-Dec-2012_time0_standard.mat',0,30);
% cd ../time30
% [time30_width,time30_length] = widthanalysis('19-Dec-2012_time30_standard.mat',30,30);
% cd ../time60
% [time60_width,time60_length] = widthanalysis('19-Dec-2012_time60_standard.mat',60,30);
% cd ../time90
% [time90_width,time90_length] = widthanalysis('20-Dec-2012_time90_standard.mat',90,30);
cd ../time120_new
[time120_width,time120_length] = widthanalysis('20-Dec-2012_time120_new_standard.mat',120,30);
cd ../time150
[time150_width,time150_length] = widthanalysis('20-Dec-2012_time150_standard.mat',150,30);

%%
width = [time0_width,time30_width,time60_width,time90_width,time120_width,time150_width];
length = [time0_length,time30_length,time60_length,time90_length,time120_length,time150_length];

%%
for i = 1:length(cell)
    width(i) = frame(1).object(i).MT_width;
end
plot(width*.08)


