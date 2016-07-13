function roc_contours(directory)
%can specify directory, otherwise uses current directory
if exist('directory') == 1
    list = dir([directory '/*CONTOURS.mat']);
else
    list = dir('*CONTOURS.mat');
end

%% roc contour files

for i = 1:numel(list)
    %fprintf('Loading: %s\n', list(i).name)

    if exist('directory') == 1
        f = load([directory list(i).name]);
    else
        f = load(list(i).name);
    end
    count = 0;
    total_count = 0;
    for k = 1:numel(f.frame)
        for j = 1:numel(f.frame(k).object)
            %fprintf('%d %d\n',k,j)
            total_count = total_count + 1;
            f.frame(k).object(j).roc = test_roc(f.frame(k).object(j));
            if f.frame(k).object(j).roc == 1
                count = count + 1;
            end
        end
    end
    fprintf('%s: %2.f%%\n',list(i).name,count/total_count*100)
    if exist('directory') == 1
        save([directory '/' list(i).name],'-struct','f');
        %fprintf('Saved: %s\n', list(i).name)
    else
        save([list(i).name],'-struct','f');
        %fprintf('Saved: %s\n', list(i).name)
    end
end
end