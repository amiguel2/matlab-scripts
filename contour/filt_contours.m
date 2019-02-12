function filt_contours(varargin)
%can specify directory, otherwise uses current directory
directory = pwd;
prefix = '';
suffix = '_feature_0_CONTOURS';
% defualt segmentation parameters
kappasmoothfilt1 = 0.3; % Keeps contours with curvature values less than given value. Inf means no positive curvature filtering. Typical value: 0.35;
kappasmoothfilt2 = -0.2; % Keeps contours with curvature values less than given value. -Inf means no negative curvature filtering. Typical value: -0.25;
areafilt = 500; % Inf means no min area filtering. Typical value: 50-250


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
if ~strcmp(directory(end),'/')
    directory = [directory '/'];
end
list = dir([directory prefix '*' suffix '.mat']);
list = list(~cellfun(@(x)strcmp(x(1),'.'),{list.name}));


%% roc contour files

for i = 1:numel(list)
    fprintf('Loading: %s\n', list(i).name)
    newname = strsplit(list(i).name,'.mat');
    newname = [newname{1} '_FILT.mat'];
    
    f = load([directory list(i).name],'frame');
    newf = struct();
    newf.frame = struct();
    count = 0;
    totalcount = 0;
    
    for k = 1:numel(f.frame)
        passed_filt = [];
        for j = 1:numel(f.frame(k).object)
            %fprintf('%d %d\n',k,j)
            totalcount = totalcount + 1;
            if f.frame(k).object(j).kappa_smooth < kappasmoothfilt1 & f.frame(k).object(j).area > areafilt & f.frame(k).object(j).kappa_smooth > kappasmoothfilt2 
                passed_filt = [passed_filt j];
                count = count + 1;
            end
        end
        if numel(passed_filt) > 0
            newf.frame(k).num_objs = numel(passed_filt);
            newf.frame(k).object = f.frame(k).object(passed_filt);
            if isfield(f.frame(k),'blank')
                newf.frame(k).blank = f.frame(k).blank;
                newf.frame(k).medblankY = f.frame(k).medblankY;
            end
        else
            newf.frame(k).num_objs = 0;
            newf.frame(k).object = [];
            if isfield(newf.frame(k),'blank')
                newf.frame(k).object = [];
            end
        end
    end
    fprintf('%s: Filt Pass: %d %2.f%%\n',list(i).name,count,count/totalcount*100)
    save([directory newname],'-struct','newf');
    save([directory newname],'kappasmoothfilt1','-append')
    save([directory newname],'kappasmoothfilt2','-append')
    save([directory newname],'areafilt','-append')
end
end