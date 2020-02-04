function [ Cw, Cwx, Cwy ] = compute_derivatives_warp( I, u0, v0, step_size, st)

dx = st.dx; dy = st.dy; %changes X_transform arguments to st in general
interp_method = st.warping_method;
M = size(I, 1); N = size(I, 2);

[idx idy] = meshgrid(1:N, 1:M);

% the step size used in the computation of the derivatives
s = step_size;

%Descriptor_transform = @correlation_transform_mex;
Cw = zeros(M, N, dx, dy);
Cw_ups = zeros(M, N, dx, dy);
Cw_ums = zeros(M, N, dx, dy);
Cw_vps = zeros(M, N, dx, dy);
Cw_vms = zeros(M, N, dx, dy);

% warp the image with the flow (u0, v0) and compute the correlation
% transform of the warped image
idxx = idx + u0;
idyy = idy + v0;
Iw = interp2(I, idxx, idyy, interp_method);

Descriptor_transform(Cw, Iw);

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

Descriptor_transform(Cw_ups, Iw_ups);
Descriptor_transform(Cw_ums, Iw_ums);
Descriptor_transform(Cw_vps, Iw_vps);
Descriptor_transform(Cw_vms, Iw_vms);

% compute the spatial derivatives
Cwx = (Cw_ups - Cw_ums)/(2*s);
Cwy = (Cw_vps - Cw_vms)/(2*s);

