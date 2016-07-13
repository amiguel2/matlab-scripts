[mw_num,mw_text,mw_raw] = xlsread('Calculated MWs with Adducts.xlsx');
value = input('Type in the MW you are looking for:\n');

val_mat = value*ones(size(mw_num));
diff = abs(mw_num-val_mat);
indx = find(abs(mw_num - val_mat) < 2.0);
fprintf('[Species] Adducts\tM/z\n');

[sortval,sortindx] = sort(diff(indx),'descend');
indx2 = indx(sortindx);
for i =1:length(indx2)
    [I,J]=ind2sub(size(mw_num),indx2(i));
    species = mw_text{I+2,1};
    adducts = mw_text{2,J+1};
    v = mw_num(I,J);
    if strcmp(adducts, 'MW') || strcmp(adducts, 'Oxidation') || strcmp(adducts,'Formylation') || strcmp(adducts,'Acetylation')
       fprintf('%s\t%f\n', strcat(species,strcat('(',adducts,')')),v);
    else
        name = strrep(adducts, 'M+', strcat(species,'+'));
        fprintf('%s\t%f\t%.3f\n', name,v,sortval(i));
    end
end
    
    
