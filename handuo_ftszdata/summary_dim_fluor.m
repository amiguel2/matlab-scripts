clear all;
close all;

widths = cell(1, 18);
lengths = cell(1, 18);
totalfluor = cell(1, 18);
halfwidth = cell(1, 18);
pkscount = cell(1, 18);

pxl = 0.064;

for i = 1 : 18
    matfiles = rdir(strcat('./s', num2str(i, '%02d'), '_1/*fluor.mat'));
    for j = 1 : length(matfiles)
        disp(matfiles(j).name);
        load(matfiles(j).name, 'frame');
        for k = 1 : length(frame.object)
            obj = frame.object(k);
            if isfield(obj, 'cont_chk') & obj.cont_chk
                if ~isnan(obj.width)
                    curfluor = obj.fluor_sig;
                    curfluor = curfluor - median(smooth(curfluor));
                    maxpeak = max(smooth(curfluor));
                    [pks, ~, halfw] = findpeaks(curfluor, ...
                        'MinPeakHeight', 0.8 * maxpeak);
                    if ~isnan(curfluor)
                        pkscount{i} = [pkscount{i}, length(pks)];
                        if ~isempty(pks) && (length(pks) == 2)
    %                         totalfluor{i} = [totalfluor{i}, sum(pks .* halfw .* pxl)];
                            totalfluor{i} = [totalfluor{i}, sum(curfluor) ./ (obj.length * pxl)];
                            widths{i} = [widths{i}, obj.width * pxl];
                            lengths{i} = [lengths{i}, obj.length * pxl];
                            halfwidth{i} = [halfwidth{i}, mean(halfw) * pxl];
                        end
                    end
                end
            end
        end
    end
end

save('fluor_dim_summary.mat', 'widths', 'lengths', ...
    'totalfluor', 'halfwidth', 'pkscount', 'pxl');
