%%
clear
clc
close all
path1='/Users/carol/Documents/RESEARCH/Huang_group/Wolverine Project/Compiled growth data';

cd(path1)
B=dir(fullfile(path1, 'D-*'));
font_size = 20;
black = 1; %which color to plot in
save_plots = 1; %save to eps file

%% define the different species

Species = struct('file',[],'name',[],'doub_rate',[],'width',[],'e_doub_rate',[],'e_width',[],'all_widths',[],'all_lambda',[]);
Species(1).name = 'K12';
% Species(2).name = 'Vc';
% Species(3).name = '0p01';
Species(2).name = 'Ec';
Species(3).name = 'St';
Species(4).name = 'Vc';
Species(5).name = 'Yp';
Species(6).name = '0p01';
Species(7).name = '0p1';
Species(8).name = '0p5';
Species(9).name = '_1_p';
Species(10).name = '10ng';

% Species(11).name = '50ng';
% Species(12).name = '100ng';
% Species(13).name = '200ng';
min_cell = 20; %minimum number of cells for file to be included in analysis
width=zeros(size(Species,2),2);
doub_rate=zeros(size(Species,2),2);
%%
for nin =1: size(Species,2)
    k = 1;
    kk = 1;
    for nn=1:size(B,1)
        path=[path1 '/' B(nn).name];
        A=dir(fullfile(path, ['18-Nov*' Species(nin).name '*_standard.mat']));
        for n=1:size(A)
            load([path '/' A(n).name])
            if size(S_out,2)>=min_cell
                Species(nin).file(k).name = A(n).name;
                Species(nin).file(k).path = path;
                Species(nin).doub_rate(k) = log(2)/lambda_m;
                Species(nin).e_doub_rate(k) = log(2)/lambda_m^2*slambda_m;
                Species(nin).width(k)=m_width;
                Species(nin).e_width(k)=sm_width;
                for in=1:size(S_out,2)
                    if S_out(in).expfit(2)>10^(-3)
                        Species(nin).all_widths(kk)=S_out(in).width;
                        Species(nin).all_lambda(kk)=S_out(in).expfit(2);
                        Species(nin).file(k).all_widths(in)=S_out(in).width;
                        Species(nin).file(k).all_lambda(in)=S_out(in).expfit(2);
                        kk = kk + 1;
                    end
                end
                k=k+1;
            end
                clearvars -except Species width doub_rate k nin nn A path path1 B kk min_cell font_size black save_plots
        end
    end
    width(nin,1)=mean(Species(nin).width(:));
    width(nin,2)=std(Species(nin).width(:));
    doub_rate(nin,1)=mean(Species(nin).doub_rate(:));
    doub_rate(nin,2)=std(Species(nin).doub_rate(:));
end

plot_growth(Species,doub_rate,width,font_size,black,save_plots);
