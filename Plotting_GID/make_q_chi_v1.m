function [rect_q, rect_chi, rect_z] = make_q_chi_v1(fname, scans, Energy, i2norm)

% Rectilinear chi-d grid; make into an input parameter at some point...
rect_chi = 3:0.5:90;
rect_q = 1:0.02:4.5;


tic
for f = 1:length(scans)
    matfile = sprintf('%s_%03d.mat', fname, scans(f));
    [q_par, q_perp, z] = open_gid_v4(matfile, Energy, 'i2norm', i2norm);
    chi = 90 - atand(q_perp./q_par); 
    q = sqrt(q_perp.^2 + q_par.^2);
    if f == 1
        [rtz, norm] = curve_to_rect(q', chi', z', rect_q, rect_chi);
        rtz_tot = rtz; 
        norm_tot = norm;
    else
        [rtz, norm] = curve_to_rect(q', chi', z', rect_q, rect_chi);
        rtz_tot = rtz_tot + rtz; 
        norm_tot = norm_tot + norm;
    end
    
end
toc

norm_tot(rtz_tot == 0) = 1.0;
rect_z = rtz_tot'./norm_tot';

