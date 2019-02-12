function shapedata = get_shapegrowthcurve_data(strain,time)

if ~exist('strain')
    strain = {'MG1655','BW25113'};
end

if ~exist('time')
    time = [0 30 60 90 120 150];
end
shapedata.strain = strain;
shapedata.time = time;
load('/Users/amiguel/Dropbox/Research/Projects/MreB_Chemgenomics/MC01 Shape Growth Curve Imaging BW and MG/MC01.1/MC01.mat');
[~,wells] = xlsread('/Users/amiguel/Dropbox/Research/Projects/MreB_Chemgenomics/analysis scripts/wells.xlsx');

widths = nan(numel(strain),96,numel(time));
lengths = nan(numel(strain),96,numel(time));
muts = cell(numel(strain),96);

for a = 1:numel(strain)
    for i = 1:96
        eval(sprintf('well = data.%s;',wells{i}));
        for t = 1:numel(time)
            idx1 = find(strcmp(strain{a},well(:,2)') & time(t) == [well{:,3}]);
            if ~isempty(idx1)
                widths(a,i,t) = nanmedian([well{idx1,5}]);
                lengths(a,i,t) = nanmedian([well{idx1,4}]);
                muts{a,i} = well{idx1,7};
            end
        end
    end
end
shapedata.widths = widths;
shapedata.lengths = lengths;
shapedata.mut = muts;
end
