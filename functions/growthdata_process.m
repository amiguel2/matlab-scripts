function growthdata_process()

% script to process growthshape curve data
folder = '/Users/amiguel/Dropbox/Research/Projects/MreB Chemgenomics/MC01 Single Cell Imaging BW and MG/RowA/';
strainfile = '/Users/amiguel/Dropbox/Research/Projects/MreB Chemgenomics/MC01 Single Cell Imaging BW and MG/RowA/SLIP_strains_rowA.xlsx';

timepoints = dir(folder);
for i = 4:4%numel(timepoints)
    if timepoints(i).isdir
        display([folder timepoints(i).name]);
        files = dir([folder '*.mat']);
        convert_rownum(files,strainfile)
    end
end

end

function output = convert_rownum(files,strainfile)
[num,txt] = xlsread(strainfile)
if rownum == 1 && strains == 2
    % 24 strains, first row MG, second row BW
    for i = 1:numel(files)
        
    end
    
elseif rownum == 2
    % 48 strains, first two rows MG, last two rows BW
end

end
