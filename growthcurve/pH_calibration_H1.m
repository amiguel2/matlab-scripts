function y = pH_calibration_H1(ratios)

    % calibration data for tecan
    % Ex1 = 490, Ex2 = 440, Em = 530, ratios = F1 / F2
    
    cali_ratios = [0.0782    1.4598    1.6347    1.8734,...
        2.2310    2.7091    3.2929    3.9454    4.6744,...
        5.3221    5.8951    6.2876    6.5561    7.2496];
    pHs = [2, 5.76, 5.95, 6.15, 6.35, 6.57, 6.77, ...
        6.99, 7.21, 7.45, 7.69, 7.89, 8.11, 12];
    
    y = interp1(cali_ratios, pHs, ratios);