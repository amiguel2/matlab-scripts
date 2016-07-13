%% get file lists
fileprefix = '*stack*';
filelist1 = dir([fileprefix,'*CONTOURS.mat']);
filelist2 = dir([fileprefix,'*_GFP.tif']);
 
%% mesh contour files
list = dir('*CONTOURS.mat');
for i = 1:numel(list)
    fprintf('Loading: %s\n', list(i).name)
    count = 0;
    f = load(list(i).name);
    %if isfield(f.frame(1).object,'mesh') == 0
        fprintf('Meshing: %s\n',list(i).name);
        for k = 1:numel(f.frame)
            for j = 1:numel(f.frame(k).object)
               try
                   % if using command line version of morph_cl, command
                   % these out
%                [m,l,w] = calculate_mesh(f.frame(k).object(j));
%                f.frame(k).object(j).mesh = m;
%                f.frame(k).object(j).cell_length = l;
%                f.frame(k).object(j).cell_width = w;
               f.frame(k).object(j).roc = test_roc(f.frame(k).object(j));
%                plot(f.frame(k).object(j).Xcont,f.frame(k).object(j).Ycont)
%                pause;
               if f.frame(k).object(j).roc == 1
                   count = count + 1;
               end
               end
            end
        end
        
         
        fprintf('%s: %d\n',list(i).name,count)
        save([list(i).name],'-struct','f');
    %end
end
 
% %% calculate fluorescence profiles
% for j=1:numel(filelist1) 
%     calculate_fluor_profiles(filelist1(j).name,filelist2(j).name,'',[]);
% end

