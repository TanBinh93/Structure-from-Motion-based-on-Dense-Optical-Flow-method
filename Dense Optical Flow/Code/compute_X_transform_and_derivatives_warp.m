%
% Author: Marius Drulea
% http://www.cv.utcluj.ro/optical-flow.html

% Reference
% Drulea, M.; Nedevschi, S., "Motion Estimation Using the Correlation Transform,"
% Image Processing, IEEE Transactions on , vol.22, no.8, pp.3260,3270, Aug. 2013

% Copyright (C) 2013 Technical University of Cluj-Napoca

function [ Cw, Cwx, Cwy ] = compute_X_transform_and_derivatives_warp( I, u0, v0, stencils, step_size, st)

dx = st.dx; dy = st.dy; %changes X_transform arguments to st in general
interp_method = st.warping_method;
M = size(I, 1); N = size(I, 2);

[idx idy] = meshgrid(1:N, 1:M);

% the step size used in the computation of the derivatives
s = step_size;

%Cw = zeros(M, N, dx, dy);

% warp the image with the flow (u0, v0) and compute the correlation
% transform of the warped image
idxx = idx + u0;
idyy = idy + v0;
Iw = interp2(I, idxx, idyy, interp_method);

Cw = FeatExtraction(Iw, st);

% warps and compute the correlations necessary for spatial derivatives
% +- s

idxx = idx + u0 + s;
idyy = idy + v0;
Iw_ups = interp2(I, idxx, idyy, interp_method);

idxx = idx + u0 - s;
idyy = idy + v0;
Iw_ums = interp2(I, idxx, idyy, interp_method);

idxx = idx + u0;
idyy = idy + v0 + s;
Iw_vps = interp2(I, idxx, idyy, interp_method);

idxx = idx + u0;
idyy = idy + v0 - s;
Iw_vms = interp2(I, idxx, idyy, interp_method);

Cw_ups = FeatExtraction(Iw_ups, st); % correlation_transform_mex(Cw_ups, Iw_ups);
Cw_ums = FeatExtraction(Iw_ums, st); % correlation_transform_mex(Cw_ums, Iw_ums);
Cw_vps = FeatExtraction(Iw_vps, st); % correlation_transform_mex(Cw_vps, Iw_vps);
Cw_vms = FeatExtraction(Iw_vms, st); % correlation_transform_mex(Cw_vms, Iw_vms);


if (stencils == 5)
    % +- 2*s
    
    idxx = idx + u0 + 2*s;
    idyy = idy + v0;
    Iw_up2s = interp2(I, idxx, idyy, interp_method);
    
    idxx = idx + u0 - 2*s;
    idyy = idy + v0;
    Iw_um2s = interp2(I, idxx, idyy, interp_method);
    
    idxx = idx + u0;
    idyy = idy + v0 + 2*s;
    Iw_vp2s = interp2(I, idxx, idyy, interp_method);
    
    idxx = idx + u0;
    idyy = idy + v0 - 2*s;
    Iw_vm2s = interp2(I, idxx, idyy, interp_method);
    
    Cw_up2s = FeatExtraction(Iw_up2s, st); % correlation_transform_mex(Cw_up2s, Iw_up2s);
    Cw_um2s = FeatExtraction(Iw_um2s, st); % correlation_transform_mex(Cw_um2s, Iw_um2s);
    Cw_vp2s = FeatExtraction(Iw_vp2s, st); % correlation_transform_mex(Cw_vp2s, Iw_vp2s);
    Cw_vm2s = FeatExtraction(Iw_vm2s, st); % correlation_transform_mex(Cw_vm2s, Iw_vm2s);
end

% compute the spatial derivatives
if (stencils == 3)
    Cwx = (Cw_ups - Cw_ums)/(2*s);
    Cwy = (Cw_vps - Cw_vms)/(2*s);
end

if (stencils == 5)
    Cwx = (Cw_um2s - 8*Cw_ums + 8*Cw_ups - Cw_up2s)/(12*s);
    Cwy = (Cw_vm2s - 8*Cw_vms + 8*Cw_vps - Cw_vp2s)/(12*s);
end


end

