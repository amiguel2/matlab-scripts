%%
clear
clc
close all
path1='/Users/carol/Documents/RESEARCH/Huang_group/Wolverine Project/Osmotic shock WGA';
cd(path1)
B=dir(fullfile(path1, 'D-*'));
date_to_anal='18-Nov-2012'; %if there is a date (which would be at the beginning of the file name in the format 25-Oct-2012
black = 1; %plot with a black background
save_plots = 0; %save to eps file

plot_g = 0; %plot growth
plot_s = 1; %plot shock
font_size = 20;
%% define the different species

Species = struct('file',[],'name',[],'doub_rate',[],'width',[],'e_doub_rate',[],'e_width',[],'all_widths',[],'all_lambda',[],'area_strain',[],'e_area_strain',[],'length_strain',[],'e_length_strain',[],'width_strain',[],'e_width_strain',[],'all_A_strain',[],'all_L_strain',[],'all_W_strain',[]);
kk = 1;
Species(kk).name = 'Yp';
kk = kk+1;
Species(kk).name = 'Ec';
kk = kk+1;
Species(kk).name = 'K12';
kk = kk+1;
Species(kk).name = 'St';
kk = kk+1;
Species(kk).name = 'MreB';
kk = kk+1;
Species(kk).name = '0p1';
kk = kk+1;
Species(kk).name = 'Vc';
kk = kk+1;
Species(kk).name = '0p01';
kk = kk+1;

% Species(8).name = '0p5';
% Species(9).name = '_1_p';
% Species(10).name = '10ng';
% Species(11).name = '50ng';
% Species(12).name = '100ng';
% Species(13).name = '200ng';
min_cell = 1; %minimum number of cells for file to be included in analysis
width=zeros(size(Species,2),2);
length=zeros(size(Species,2),2);
doub_rate=zeros(size(Species,2),2);
A_strain=zeros(size(Species,2),2);
L_strain=zeros(size(Species,2),2);
W_strain=zeros(size(Species,2),2);

%%
for nin =1: size(Species,2)
    k = 1;
    kk = 1;
    for nn=1:size(B,1)
        path2=[path1 '/' B(nn).name];
        A=dir(fullfile(path2, [date_to_anal '*' Species(nin).name '*shock_standard.mat']));
        for n=1:size(A)
            load([path2 '/' A(n).name])
            if size(S_out,2)>=min_cell
                Species(nin).file(k).name = A(n).name;
                Species(nin).file(k).path = path2;
                Species(nin).doub_rate(k) = log(2)/lambda_m;
                Species(nin).e_doub_rate(k) = log(2)/lambda_m^2*slambda_m;
                Species(nin).area_strain(k) = m_d_A;
                Species(nin).e_area_strain(k) = s_d_A;
                Species(nin).length_strain(k) = m_d_l;
                Species(nin).e_length_strain(k) = s_d_l;
                Species(nin).width_strain(k) = m_d_w;
                Species(nin).e_width_strain(k) = s_d_w;
                Species(nin).width(k)=m_width;
                Species(nin).e_width(k)=sm_width;
                Species(nin).length(k)=m_length;
                Species(nin).e_length(k)=sm_length;
                for in=1:size(S_out,2)
                        Species(nin).all_widths(kk)=S_out(in).width;
                        Species(nin).all_eccentricity(kk)=S_out(in).eccentricity;
                        Species(nin).all_lengths(kk)=S_out(in).length;
                        Species(nin).all_lambda(kk)=S_out(in).expfit(2);
                        Species(nin).all_A_strain(in)=S_out(in).area_strain;
                        Species(nin).all_L_strain(in)=S_out(in).length_strain;
                        Species(nin).all_W_strain(in)=S_out(in).width_strain;
                        Species(nin).file(k).all_widths(in)=S_out(in).width;
                        Species(nin).file(k).all_lengths(in)=S_out(in).length;
                        Species(nin).file(k).all_lambda(in)=S_out(in).expfit(2);
                        Species(nin).file(k).all_A_strain(in)=S_out(in).area_strain;
                        Species(nin).file(k).all_L_strain(in)=S_out(in).length_strain;
                        Species(nin).file(k).all_W_strain(in)=S_out(in).width_strain;
                        kk = kk + 1;
                end
                k=k+1;
            end
                clearvars -except black Species width doub_rate k nin nn A path path1 B kk min_cell plot_g plot_s A_strain L_strain W_strain font_size save_plots path2 date_to_anal length
        end
    end
    width(nin,1)=mean(Species(nin).width(:));
    width(nin,2)=std(Species(nin).width(:));
    length(nin,1)=mean(Species(nin).length(:));
    length(nin,2)=std(Species(nin).length(:));
    doub_rate(nin,1)=mean(Species(nin).doub_rate(:));
    doub_rate(nin,2)=std(Species(nin).doub_rate(:));
    A_strain(nin,1)=mean(Species(nin).area_strain(:));
    A_strain(nin,2)=std(Species(nin).area_strain(:));
    L_strain(nin,1)=mean(Species(nin).length_strain(:));
    L_strain(nin,2)=std(Species(nin).length_strain(:));
    W_strain(nin,1)=mean(Species(nin).width_strain(:));
    W_strain(nin,2)=std(Species(nin).width_strain(:));
end
if plot_g
    plot_growth(Species,doub_rate,width,font_size,black,save_plots)  
end

if plot_s
    plot_shock(Species,doub_rate,width,length,A_strain,L_strain,W_strain,font_size,black,save_plots) 
end
