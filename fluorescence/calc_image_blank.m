function calc_image_blank(contour,fluorstack)

% fprintf('Calculating blanks')
Nf = imfinfo(fluorstack);
f = load(contour);


% if numel(f.frame) <= numel(Nf)
if ~isfield(f.frame(1),'blank')
    fprintf('...Blank not calculated\n')
    calc_blank = 1;
else
%     fprintf('Number of frames do not match\n');
      fprintf('...Blank already calculated\n')
      calc_blank = 0;
end

if ~isfield(f.frame(1),'medblankY')
    fprintf('...medblankY not calculated\n')
    calc_medblankY = 1;
else
%     fprintf('Number of frames do not match\n');
      fprintf('...medblankY already calculated\n')
      calc_medblankY = 0;
end

if calc_blank == 0 & calc_medblankY == 0
    return
end

    tic
    for i = 1:numel(Nf)
        fprintf('%d ',i)
        blank1img = imread(fluorstack,i);
        if calc_blank
        [counts,centers] = hist(double(reshape(blank1img,[1,numel(blank1img)])),100);
        [pks,locs] = findpeaks(counts,centers,'MinPeakHeight',3*10^5);
        if isempty(pks)
            [counts,centers] = hist(double(reshape(blank1img,[1,numel(blank1img)])),500);
            f.frame(i).blank = centers(max(counts) == counts);
        else
            f.frame(i).blank = locs(1);
        end
        end
        if calc_medblankY
        f.frame(i).medblankY = median(blank1img,2);
        end
    end
    fprintf('\nDone!\n')
    save(contour,'-struct','f');
    toc

end
