function kymo = plot_singcellkymograph(param,normalize)
% plots the specified param (represented as a cell) as a function of time

% get largest param size for kymo
N = max(cellfun(@numel,param));
kymo = zeros(numel(param),N);

startmen = mean(param{1});
% for each param
for j = 1:numel(param)
    fps = param{j}';
    if exist('normalize') == 1
        if normalize == 1
            fps = fps - min(fps); % subtract baseline
        elseif normalize == 2
            fps = fps - startmen;%median(fps); % subtract mean
            fps(fps<0) = 0;
        end  
    end
    
    % determine the padding on each side
    N1 = (N-numel(fps))/2; 
    if rem(N1,1) ~= 0
        tmp = padarray(fps,[0,floor(N1)],0,'pre');
        kymo(j,:) = padarray(tmp,[0,floor(N1)+1],0,'post');
    elseif N1 < 0
        fprintf('Error: cell bigger than last cell')
        return
    else
        kymo(j,:) = padarray(fps,[0,N1]);
    end
end

imagesc(kymo)
end
