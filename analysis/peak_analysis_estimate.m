t = chrom.t(1);
l=length(chrom.blank_sub_data);
ta = sum(chrom.blank_sub_data(:,2));
x1=zeros(length(Peaks),1);
x2=zeros(length(Peaks),1);
percent=zeros(length(Peaks),1);
name= cell(length(Peaks),1,1);
for i = 1:length(Peaks)
   name{i} = strrep(Peaks(i).name,'-',''); 
   x1(i,1) = find(chrom.blank_sub_data(:,1) > Peaks(i).interval(1),1);
   x2(i,1) = find(chrom.blank_sub_data(:,1) > Peaks(i).interval(2),1);
   percent(i,1) = (sum(chrom.blank_sub_data(x1(i):x2(i),2))/ta)*100;
   eval([name{i} '= percent(i,1)']);
end

M = M3 + M3G + M4 + M5G + M5 + M5N;
D = D45G + D44 + D45 + D45GN + D44N1 + D44N2 + D45N;
T = T445G + T444 + T445 + T444GN + T444N + T445N;
lipoprotein = 0;
anhydro = D44N1+D44N2+D45N+D45GN + T444GN + T444N;
glycan = 100/(anhydro);
crosslinking = D + 2*T;
dap = 0;
penpep = M5+D45+T445+D45N+T445N;
pengly =  0;

c = {crosslinking,glycan,M,D,T,lipoprotein,anhydro,dap,penpep,pengly}
c = c'
