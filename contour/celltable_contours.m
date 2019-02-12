list = dir('*ROC.mat');

for i = 1:numel(list)
    fprintf('%s...',list(i).name)
    make_celltable(list(i).name);
    fprintf('Done!\n')
end