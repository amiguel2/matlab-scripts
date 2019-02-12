clear all;
close all;

load('fluor_dim_summary.mat');

mw = zeros(1, 18);
sw = zeros(1, 18);
ml = zeros(1, 18);
sl = zeros(1, 18);
mfluor = zeros(1, 18);
sfluor = zeros(1, 18);
mfluorPerLength = zeros(1, 18);
sfluorPerLength = zeros(1, 18);
mfhw = zeros(1, 18);
sfhw = zeros(1, 18);

colors = default_colormap(7);

inds = [1 : 9 11 : 15 17 : 18];
% inds = 1 : 18;

for i = 1 : 18
    [mw(i), sw(i)] = calc_mean_sem(widths{i} * 0.9);
    [ml(i), sl(i)] = calc_mean_sem(lengths{i});
    [mfluor(i), sfluor(i)] = calc_mean_sem(totalfluor{i});
    [mfluorPerLength(i), sfluorPerLength(i)] = calc_mean_sem(totalfluor{i} ./ lengths{i});
    [mfhw(i), sfhw(i)] = calc_mean_sem(halfwidth{i});
    [mfd(i), sfd(i)] = calc_mean_sem(totalfluor{i} ./ halfwidth{i});
end


scatter_errorbar('new');
scatter_errorbar('data', mw(inds), ml(inds), sw(inds), sl(inds), ...
    'LineProp', {'color', colors(1, :)}, ...
    'MarkerProp', {'MarkerEdgeColor', 'non', 'MarkerFaceColor', colors(1, :), ...
    'MarkerSize', 10});
scatter_errorbar('plot');
axis([0.7 2 2 8]);
xlabel('Cell width (\mum)');
ylabel('Cell length (\mum)');
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 20);

scatter_errorbar('new');
scatter_errorbar('data', mw(inds), mfhw(inds), sw(inds), sfhw(inds), ...
    'LineProp', {'color', colors(1, :)}, ...
    'MarkerProp', {'MarkerEdgeColor', 'non', 'MarkerFaceColor', colors(1, :), ...
    'MarkerSize', 10});
scatter_errorbar('plot');
xlim([0.7 1.8]);
xlabel('Cell width (\mum)');
ylabel('FtsZ ring half width (\mum)');
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 20);

scatter_errorbar('new');
scatter_errorbar('data', mw(inds), mfd(inds), sw(inds), sfd(inds), ...
    'LineProp', {'color', colors(1, :)}, ...
    'MarkerProp', {'MarkerEdgeColor', 'non', 'MarkerFaceColor', colors(1, :), ...
    'MarkerSize', 10});
scatter_errorbar('plot');
xlim([0.7 1.8]);
xlabel('Cell width (\mum)');
ylabel('FtsZ areal density (a.u.)');
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 20);
export_fig -pdf ftsz-density


load('blurlab_model.mat', 'p');

res = cell(1, 3);

scatter_errorbar('new');
hold on;
for i = 1 : 3
    fun = @(x) sum((x * polyval(p{i}, mw(inds)) - mfluor(inds)) .^ 2);
    x0 = 0.01;
    x = fminsearch(fun, x0);
    res{i} = x * polyval(p{i}, mw(inds)) - mfluor(inds);
    disp(fun(x));
    w = 0.7 : 0.01 : 1.8;
    plot(w, x * polyval(p{i}, w), 'color', colors(i, :), 'LineWidth', 2);
    x
    fun(x)
end
scatter_errorbar('data', mw(inds), mfluor(inds), sw(inds), sfluor(inds), ...
    'LineProp', {'color', colors(5, :)}, ...
    'MarkerProp', {'MarkerEdgeColor', 'non', 'MarkerFaceColor', colors(5, :), ...
    'MarkerSize', 10});
scatter_errorbar('plot');
hold off;
xlim([0.7 1.8]);
xlabel('Cell width (\mum)');
ylabel('Total fluorescence (a.u.)');
legend('Constant mass', 'Constant area density', 'Constant concentration', 'Location', 'NorthWest');
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 20);
%%
figure('color', 'w');
hold on;
for i = 1 : 3
    plot(mw(inds), res{i}, '.', 'MarkerSize', 30);
end
plot([0.6 1.8], [0 0], 'k-');
hold off;
xlabel('Cell width (\mum)');
ylabel('Fitting residues (a.u.)');
xlim([0.7 1.8]);
legend('Constant mass', 'Constant area density', 'Constant concentration', 'Location', 'SouthWest');
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 20);

save('stat_fluor_dim.mat', 'm*', 's*');
% scatter_errorbar('new');
% scatter_errorbar('data', mw, mfluorPerLength, sw, sfluorPerLength, ...
%     'LineProp', {'color', colors(1, :)}, ...
%     'MarkerProp', {'MarkerEdgeColor', 'non', 'MarkerFaceColor', colors(1, :), ...
%     'MarkerSize', 10});
% scatter_errorbar('plot');
% xlabel('Cell width (\mum)');
% ylabel('Total fluorescence per cell length (a.u.)');
% set(findall(gcf, '-property', 'FontSize'), 'FontSize', 20);