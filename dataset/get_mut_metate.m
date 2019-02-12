function data = get_mut_metate(mut)
num = str2num(mut(2:end-1));
load('/Users/amiguel/Dropbox/Research/Projects/MreB Chemgenomics/MC04 MreB Chemical genomics screen/Protocol/MreB_metate.mat')
idx = find(cellfun(@(x) strcmp(x,mut),{protein(num).mutations.mutation}));
data = protein(num).mutations(idx);
end