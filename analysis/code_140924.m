%%
image_folder='/Users/amiguel/Documents/Imaging/14-09-17/BW25113_trp_mut_ftsz_ceph_3.5ugml_35ms_GFP_100ms_phase_1/stacks';
script_folder='/Users/amiguel/Documents/MATLAB/matlab_scripts/analysis/FtsZ';
cd(script_folder)
list = dir([image_folder,'/*.mat']);
for i = 1:length(list)
    fprintf('list(%d) \t%s\n',i,list(i).name)
end

%%
contourfile = [image_folder,'/',list(2).name];
[frame,cellid] = extract_filtered_cells(contourfile);
cell_list = cellid(find(frame == 1));
%%
[fluor_profile,t] = contour_fluor_cell_time(contourfile,cell_list(1));

%%
imagesc(fluor_profile)
%%
imagesc(fluor_profile(1,:))
%%
plot(fluor_profile(1,:))
[x,y]=findpeaks(fluor_profile(1,:));
hold on;
scatter(x,y)

%%
idx = find(y-mean(y) > 0.15*mean(y));
plot(fluor_profile(1,:))
hold on;
scatter(x,y)
scatter(x(idx(1)),y(idx(1)),'red')
scatter(x(idx(2)),y(idx(2)),'red')
plot([x(idx(1)),x(idx(2))],[y(idx(2)),y(idx(2))],'red')
ring_distance = abs(x(idx(1))-x(idx(2)));
text(((x(idx(1))+x(idx(2)))/2),((y(idx(2))+y(idx(2))/2)),[num2str(ring_distance),' pixels'])
fprintf('%3.2f', ring_distance)

%%
image_folder='/Users/amiguel/Documents/Imaging/14-09-17/BW25113_trp_mut_ftsz_ceph_3.5ugml_35ms_GFP_100ms_phase_1/stacks';
script_folder='/Users/amiguel/Documents/MATLAB/matlab_scripts/analysis/FtsZ';
cd(script_folder)
list = dir([image_folder,'/*.mat']);


%%

memory = []
dist = []
for a = 1:20
    fr = a;
    for i = 1:5
        contourfile = [image_folder,'/',list(i).name];
        [frame,cellid] = extract_filtered_cells(contourfile);
        cell_list = cellid(find(frame == fr));
        for j = 1:length(cell_list)
            fluor_profile = contour_fluor_cell(contourfile,cell_list(j),fr);
            [y,x]=findpeaks(smooth(fluor_profile,20),'minpeakdistance',50);
            idx = find(x > .1*length(fluor_profile) & x < .9*length(fluor_profile));
            if length(idx) == 2
                figure(1)
                plot(fluor_profile)
                hold on;
                scatter(x,y)
                ring_distance = abs(x(idx(1))-x(idx(2)));
                plot([x(idx(1)),x(idx(2))],[y(idx(2)),y(idx(2))],'red')
                fprintf('Added: %3.2f\n', ring_distance)
                dist = [dist ring_distance];
            elseif length(idx) >2
                figure(1)
                plot(fluor_profile)
                hold on;
                scatter(x,y)
                num = 1;
                k_o = 1;
                for k = 1:length(idx)-1
                    num = 1;
                    if k < k_o
                        display('Skipped')
                    else
                        ring_distance = abs(x(idx(k))-x(idx(k+num)));
                        while ring_distance < 50 && num+k < length(idx)
                            num = num +1;
                            ring_distance = abs(x(idx(k))-x(idx(k+num)));
                        end
                        if ring_distance > 50 && num+k 
                            scatter(x(idx(k)),y(idx(k)),'red')
                            scatter(x(idx(k+num)),y(idx(k+num)),'red')
                            plot([x(idx(k)),x(idx(k+num))],[y(idx(k+num)),y(idx(k+num))],'red')
                            text(x(idx(k+num)),y(idx(k+num)),[num2str(ring_distance),' pixels'])
                            display(ring_distance)
                            result = input('1. Add to distribution?','s');
                            if result == 'y'
                              k_o = num+k;
                              num = 1;
                              fprintf('Added: %3.2f\n', ring_distance)
                              dist = [dist ring_distance];
                            elseif result == 'm'
                               while result ~= 'y' && num+k < length(idx)
                                   num = num +1;
                                   scatter(x(idx(k+num)),y(idx(k+num)),'green')
                                   plot([x(idx(k)),x(idx(k+num))],[y(idx(k+num)),y(idx(k+num))],'green')
                                   ring_distance = abs(x(idx(k))-x(idx(k+num)));
                                   text(x(idx(k+num)),y(idx(k+num)),[num2str(ring_distance),' pixels'])
                                   display(ring_distance)
                                   result = input('2. Add to distribution?','s');
                               end
                               if result == 'y'
                                   k_o = num+k;
                                   num = 1;
                                   fprintf('Added: %3.2f\n', ring_distance)
                                   dist = [dist ring_distance];
                               end

                            else
                                k_o = k;
                                num=1;
                            end
                        end
                    end
                end
            end
            hold off;
        end
    end
end