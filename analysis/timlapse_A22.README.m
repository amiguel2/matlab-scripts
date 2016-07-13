

clear;
%% variables 

fileprefix = {'A22-0-*','A22-0.25-','A22-0.5-','A22-0.75-','A22-1-','A22-2-'};
timeshift =[11,8,6,7,6,8];
title={'0 ug/ml A22','0.25 ug/ml A22','0.5 ug/ml A22','0.75 ug/ml A22','1 ug/ml A22','2 ug/ml A22'};
output={'0-avgfr.pdf','0.25-avgfr.pdf','0.5-avgfr.pdf','0.75-avgfr.pdf','1-avgfr.pdf','2-avgfr.pdf'}


i = 1

filelist = dir([fileprefix{i},'*_data.mat']);



l = [];
l2 = [];
w = [];
w2 = [];
f = [];
t = [];
ft = [];
file = [];
k0 = [];
fr = [];


%%%% Set timeshift

%timeshift = 0;


for j=1:numel(filelist)
    load(filelist(j).name)
    fi = data.fi;
    c0 = data.params.color0;
    c1 = data.params.color1;
%     maxdifff = zeros(1,numel(fi));
%     
%     for j=1:numel(fi)
%         if (numel(fi)>0)
%             maxdifff(j) = max(abs(diff(data.fluor_curves{fi(j)}/data.fluor_curves{fi(j)}(1))));
%         else
%             maxdifff(j) = 1000000;
%         end
%     end
% 
% fi = find(maxdifff'<0.1);
    
    
    n = size(data.length_curves,2);
    m = size(data.fluor_time,2);
    hold on;
    for k =1:numel(fi)
        c = c0+(c1-c0)*(k-1)/(numel(fi)-1);
        p = size(data.width_curves{fi(k)},2);
        p1 = size(data.fluor_curves{fi(k)},2);
        l = [l data.length_curves{fi(k)}];
        ft = [ft data.fluor_time{fi(k)}+timeshift(i)-1];
        f = [f data.fluor_curves{fi(k)}];
        w = [w data.width_curves{fi(k)}];
        t = [t data.time_curves{fi(k)}+timeshift(i)-1];
        file = [file ones(1,p)*j];
        file1 = [file ones(1,p1)*j];
        k0 = [k0 ones(1,p)*k];
        k1 = [k0 ones(1,p1)*k];
        
        
        f_rate = diff(data.fluor_curves{fi(k)})./diff(data.time_curves{fi(k)});
        plot(data.time_curves{fi(k)}(1:end-1)+timeshift(i),smooth(f_rate),'Color',c);
        fr = [ fr [f_rate NaN]];
        
    end
    hold on;

%        for s=1:numel(fi)
%         c = c0+(c1-c0)*(s-1)/(numel(fi)-1);
%         nnn=numel(data.fluor_curves{fi(s)});
% 
%         %plot(data.time_curves{fi(s)}(1:end-1)+timeshift(i),smooth(f_rate{s}),'Color',c);
%     end
    
    %hold on;
    %plot_width_time(data,timeshift(i)-1)
    %plot_fluor_width(data)
    %plot_fluor_time(data,timeshift(i)-1)
end

begin=min(t);
last=max(t);
avg_fr = nan(1,last);
time = nan(1,last);
sd = nan(1,last);

for a=begin:last
    ind = find(t == a);
    numel(ind)
    time(a) = a;
    avg_fr(a) = nanmean(fr(ind));
    sd(a) = std(w(ind));
end

hold on;
plot(time,smooth(avg_fr,10),'b','LineWidth',1.25)

    
    ylim([-75 75])
    text(10,1200,string)
    text(35,60,title(i),'FontSize',18)
    xlabel('Time (min)')
    ylabel('Fluorescence Rate (A.U./min)')
    
print('-dpdf',output{i});

%%
% title=['2 ug/ml A22'];
% text(1.8,1200,title,'FontSize',18)
% xlim([0.9 2.6])
% ylim([0 60])
% 
% hold off;

% x = find(t == 10)
% hist(w(x))

%hist(w,100)
%xlim([0.9 1.5])
%Linear fit for width
% % 
%  hold on;
% fi = find(t <= 30);
% plot(0:60,polyval(polyfit(t(fi),w(fi),1),0:60,1),'LineWidth',1.25);
% ylim([0.9 2])
% xlim([0 60])
% line(timeshift(i)*ones(1,1411),-10:1400,'LineStyle',':','Color',[0.5 0.5 0.5])
% string=['Start time: ',num2str(timeshift(i)),' min'];
% text(10,1.8,string)
% text(35,1.9,title{i},'FontSize',18)
% hold off

% Linear fit for fluorescence
hold on;
fi = find(ft > 30);
plot(0:60,polyval(polyfit(ft(fi),f(fi),1),0:60,1),'LineWidth',1.25);
ylim([0 1400])
xlim([0 60])
line(timeshift(1)*ones(1,1411),-10:1400,'LineStyle',':','Color',[0.5 0.5 0.5])
string=['Start time: ',num2str(timeshift(i)),' min']
text(10,1200,string)
text(35,1000,title(i),'FontSize',18)
hold off;

% ylim([0 2.5])
% ylim([0:200:1500]);
% xlim([0:2.8]);

% figure(1);
% hold on;
% M=[t;w;l;file;k0]'
% M1=[ft;f;w2]'
% M1=sort(M1,1)
% M=sort(M,1)
%plot(smooth(M(:,1),100),smooth(M(:,2),50),'Color',[0 0 0],'LineWidth',1.25);


% avg_len = [];
% time =[];
% avg_wid = [];
% avg_fluor=[];
% avg_fluor2=[];
% 
% for k = 1:numel(data.length_curves)
%     ts = unique(t{k});
%     for i=1:numel(ts)
%         time = [time ts(i)];
%         ind = find(t{k} == ts(i));
%         avg_len = [avg_len sum(avg_len)+mean(l{ind})];
%         avg_wid = [avg_wid sum(avg_wid)+mean(w{ind})];
%         avg_fluor = [avg_fluor sum(avg_fluor)+(mean(f{ind}))];
% 
%         %ind_ft = find(ft == ts(i));
%         %avg_fluor2 = [avg_fluor2 mean(f(ind_ft))];
% 
%     end
% end
% 
% plot(time,avg_wid)


