function kappa = get_curvature(mesh)
    m = [[mesh(1:end-1,1);flipud(mesh(2:end,3))] [mesh(1:end-1,2);flipud(mesh(2:end,4))]];
    kappa = contour2curvature(m(:,1),m(:,2));
end