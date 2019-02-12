function [metate_cellwidth,metate_mut] = get_metate_widths()
[~,muts] = xlsread('/Users/amiguel/Dropbox/Research/Projects/MreB_Chemgenomics/analysis scripts/mgmuts.xlsx');
[~,wells] = xlsread('/Users/amiguel/Dropbox/Research/Projects/MreB_Chemgenomics/analysis scripts/wells.xlsx');
load('/Users/amiguel/Dropbox/Research/Projects/MreB_Chemgenomics/Single Cell Size/MreB_metate.mat')

metate_cellwidth = [];
metate_mut = {};
for i = 1:96
    mut = muts{i};
    num = str2num(mut(2:end-1));
    idx = find(strcmp(extractfield(protein(num).mutations,'mutation'),mut));
    metate_cellwidth = [metate_cellwidth mean(protein(num).mutations(idx).widths)];
    metate_mut = [metate_mut mut];
end
end
    
    