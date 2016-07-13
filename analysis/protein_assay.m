%% Functionality to
% plot all, by day, by species, by sample #


%% Parameters
c = cbrewer('qual','Set1',7);

%% File Locations
protein_assay_File='/Users/amiguel/Documents/Research/Spreadsheets/UPLC Sample Protein Assay.xlsx';
sample_File='/Users/amiguel/Documents/Research/Spreadsheets/UPLC Samples.xlsx';
pa,standard,sample = read_protein_assay_data(protein_assay_File,sample_File);



lr = polyfit(sm,sp,1);

calc_pc = @(b) b*lr(1) + lr(2);

plot(sm,sp,'LineWidth',3,'Color',c(1,:))
title('Protein Assay')
xlabel('Absorbance (A.U.) at 750 nm')
ylabel('Protein Concentration')
hold on;

scatter(mean(Btheta),calc_pc(mean(Btheta)),50,'black','MarkerFaceColor',c(2,:))
scatter(mean(BthetaM),calc_pc(mean(BthetaM)),50,'black','MarkerFaceColor',c(3,:))
scatter(mean(M886),calc_pc(mean(M886)),50,'black','MarkerFaceColor',c(4,:))
scatter(mean(M887),calc_pc(mean(M887)),50,'black','MarkerFaceColor',c(5,:))
scatter(mean(M26014),calc_pc(mean(M26014)),50,'black','MarkerFaceColor',c(6,:))
scatter(mean(M703),calc_pc(mean(M703)),50,'black','MarkerFaceColor',c(7,:))

errorbar(mean(Btheta),calc_pc(mean(Btheta)),std(Btheta),'Color',c(2,:))
errorbar(mean(BthetaM),calc_pc(mean(BthetaM)),std(BthetaM),'Color',c(3,:))
errorbar(mean(M886),calc_pc(mean(M886)),std(M886),'Color',c(4,:))
errorbar(mean(M887),calc_pc(mean(M887)),std(M887),'Color',c(5,:))
errorbar(mean(M26014),calc_pc(mean(M26014)),std(M26014),'Color',c(6,:))
errorbar(mean(M703),calc_pc(mean(M703)),std(M703),'Color',c(7,:))

% scatter(Btheta,calc_pc(Btheta),50,'black','MarkerFaceColor',c(2,:))
% scatter(BthetaM,calc_pc(BthetaM),50,'black','MarkerFaceColor',c(3,:))
% scatter(M886,calc_pc(M886),50,'black','MarkerFaceColor',c(4,:))
% scatter(M887,calc_pc(M887),50,'black','MarkerFaceColor',c(5,:))
% scatter(M26014,calc_pc(M26014),50,'black','MarkerFaceColor',c(6,:))
% scatter(M703,calc_pc(M703),50,'black','MarkerFaceColor',c(7,:))


hold off;
legend('Standard','B theta','B theta Mutant', 'G207C', 'L322Q','A53T/L322Q','A53T','Location','NorthWest')
xlim([0.1,0.24])
ylim([0.2,0.8])

pc = [calc_pc(mean(Btheta))
calc_pc(mean(BthetaM))
calc_pc(mean(M886))
calc_pc(mean(M887))
calc_pc(mean(M26014))
calc_pc(mean(M703))]