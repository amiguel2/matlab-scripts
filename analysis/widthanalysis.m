% This code utilizes Carolina's analysis code to identify single cells that
% are for experiemental analysis. It takes those specific single cells and
% saves them in a large matrix, then does normalizing, mean and standard
% deviation calculations 
% 
listfile = 'Pos5_phase[gfp]_CONTOURS.mat';
starttime = 0;
maxtime = 120;

% function [timelapse_mw_r,timelapse_ml_r] = widthanalysis(listfile, starttime,maxtime)
load(listfile);
timelapse = NaN(length(S_out),maxtime);
timelapse_length = NaN(length(S_out),maxtime);
for j = 1:length(S_out)
    load(S_out(1,j).file)
    ID = S_out(1,j).ID;
    for i = 1:length(frame)
        for k = 1:length(frame(1,i).object)
            
            if frame(1,i).num_cells ~= 0 && ~isempty(frame(1,i).object(1,k).cellID)
                if frame(1,i).object(1,k).on_edge == 0 && ~isempty(frame(1,i).object(1,k).MT_width)
                    if frame(1,i).object(1,k).cellID == ID
                        timelapse(j,i) = frame(1,i).object(1,k).MT_width;
                        timelapse_length(j,i) = frame(1,i).object(1,k).MT_length;
                    end
                end
            end
        end
        if timelapse(j,i) == 0
            timelapse(j,i) = NaN;
        end
        if timelapse_length(j,i) == 0
            timelapse_length(j,i) = NaN;
        end
    end
end


% Normalized Width

timelapse = timelapse.*.08;
timelapse_length = timelapse_length*.08;

%%

timelapse_norm = timelapse;
%timelapse_length_norm = timelapse_length;
for i = 1:size(timelapse_norm,1)
    count = 1;
    while isnan(timelapse_norm(i,count)) && count < size(timelapse_norm,2)
        count = count +1;
    end
    if ~isnan(timelapse_norm(i,count))
    timelapse_norm(i,:) = timelapse_norm(i,:)./timelapse_norm(i,count);
    %timelapse_length_norm(i,:) = timelapse_length_norm(i,:)./timelapse_length_norm(i,count);
    end
end

%Growth Curve
%for i = 1:length(timelapse_length)-1
    %growthrate(i) = (timelapse_length(i+1)-timelapse_length(i)) ./ timelapse_length(i);
%end

% Mean and SD
figure;
hold on;
for i = 1:size(timelapse_norm,2)
    timelapse_mw_r(i) = nanmean(timelapse(:,i));
    %timelapse_ml_r(i) = nanmean(timelapse_length(:,i));
    timelapse_mw(i) = nanmean(timelapse_norm(:,i));
    %timelapse_ml(i) = nanmean(timelapse_length_norm(:,i));
    timelapse_sd_w(i) = nanstd(timelapse_norm(:,i));
    %timelapse_sd_l(i) = nanstd(timelapse_length_norm(:,i));
    errorbar((starttime+i),timelapse_mw(i),timelapse_sd_w(i));
end
%LM1 = LinearModel.fit(1:60,timelapse_mw(1:60));
LM1 = LinearModel.fit(starttime:(starttime+maxtime-1),timelapse_mw);
scatter(1:120,timelapse_mw)
plot(LM1);
title('Linear Fit of Normalized Mean Width');
xlabel('time (min)')
ylabel('Width')
hold off;

figure;
hold on;
for p = 1:size(timelapse,1)
plot(1:maxtime,timelapse(p,:));
end
title('Individual Traces of Single Cell Width (Real)');
xlabel('time (min)')
ylabel('Width (um)')
hold off;


figure;
hold on;
for q = 1:size(timelapse_norm,1)
plot(1:maxtime,timelapse_norm(q,:));
end
title('Individual Traces of Single Cell Width (Normalized)');
xlabel('time (min)')
ylabel('Width (um)')
hold off;

figure;
hold on;
for i = 1:length(timelapse_ml)
   errorbar((starttime+i),timelapse_ml(i),timelapse_sd_l(i));
end

LM2 = LinearModel.fit(starttime:(starttime+maxtime-1),timelapse_ml);
plot(LM2);
title('Linear Fit of Normalized Mean Length');
xlabel('time (min)')
ylabel('Length')
hold off;

% figure;
% hold on;
% for p = 1:size(timelapse_length,1)
% plot(1:maxtime,timelapse_length(p,:));
% end
% title('Individual Traces of Single Cell Length (Real)');
% xlabel('time (min)')
% ylabel('Length (um)')
% hold off;
% 
% 
% figure;
% hold on;
% for q = 1:size(timelapse_length_norm,1)
% plot(1:maxtime,timelapse_length_norm(q,:));
% end
% title('Individual Traces of Single Cell Length (Normalized)');
% xlabel('time (min)')
% ylabel('Length (um)')
% hold off;

s = input('Save? 1 if yes    ');
if s == 1
saveas(figure(1),'LM_width.fig');
saveas(figure(1),'LM_width.pdf');
saveas(figure(2),'width_real.fig');
saveas(figure(2),'width_real.pdf');
saveas(figure(3),'width_norm.fig');
saveas(figure(3),'width_norm.pdf');
% saveas(figure(4),'LM_length.fig');
% saveas(figure(4),'LM_length.pdf');
% saveas(figure(5),'length_real.fig');
% saveas(figure(5),'length_real.pdf');
% saveas(figure(6),'length_norm.fig');
% saveas(figure(6),'length_norm.pdf');


end

% end


