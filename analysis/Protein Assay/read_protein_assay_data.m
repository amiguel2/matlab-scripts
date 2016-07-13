function [pa_data,standard,sample] = read_protein_assay_data(pa_file,sample_file)
[n,t,pa_data] = xlsread(pa_file,1);
[n1,t1n standard] = xlsread(pa_file,2);
[n1,t1,sample] = xlsread(sample_file,1);
end
