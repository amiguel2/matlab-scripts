function y = pH_calibration_tecan(ratios)

    % calibration data for tecan
    % Ex1 = 490, Ex2 = 440, Em = 530, ratios = F1 / F2
    
    cali_ratios = [0.123736606820062,2.23238026428365,2.49214828394395, ...
        2.84311253273687,3.36694451245070,4.05275942773444,...
        4.87895860147345,5.87748090035248,6.87129964309004,...
        7.80631882399830,8.67186166214294,9.15898093415872,...
        9.64537737610874,10.7878775860334];
    
    pHs = [2, 5.76, 5.95, 6.15, 6.35, 6.57, 6.77, ...
        6.99, 7.21, 7.45, 7.69, 7.89, 8.11, 12];
    
    y = interp1(cali_ratios, pHs, ratios);