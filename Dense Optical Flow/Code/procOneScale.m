function [u, v, u_, v_] = procOneScale(u, v, u_, v_, ...
    I1, I2, I1c_for_bf, st, level)

M = size(I1, 1); N = size(I1, 2);
nx = st.nx; ny = st.ny;
stencils = 3;
%% Bilateral weights
% settings for computing the bilateral coefficients
sigma_c = 5; % for color
sigma_d = 3; % for distance

% transform from RGB to Lab color space
I1_Lab = RGB2Lab(I1c_for_bf);

% compute the bilateral coefficients
bf = compute_bilateral_filter(I1_Lab(:, :, 1), I1_Lab(:, :, 2), I1_Lab(:, :, 3), nx, ny, sigma_c, sigma_d);
W_bf = max(bf, 1e-09); % avoid further divisions by zero

%%
% set the numbers of stencils and the step_size for computing the derivatives
step_size = 1; 

[C1, C1x, C1y] = compute_X_transform_and_derivatives_warp(I1, zeros(M, N), zeros(M, N),stencils, step_size, st);

% warping
qu = zeros(M, N, st.nx, st.ny);
qv = zeros(M, N, st.nx, st.ny);
for k = 1:st.warps
    % median filter helps to jump over local minima
    u0 = medfilt2(u_, [3 3], 'symmetric');
    v0 = medfilt2(v_, [3 3], 'symmetric');
    occ_condition = (level <= 2 && k >= 1); % apply occlusion refinement only on the finest two levels
    Lambdas = st.lambda * ones(M, N);
    if (occ_condition == 1)
        % occlusion aware refinement, based on the uniqueness criterion; based on [12]        
        [occ, BB] = occlusions_map_mex(u, v);
        occ2 = min(max(0, occ - 1), 1);
        occ_cost = max(1-occ2, 0.001);
        Lambdas = st.lambda*ones(M, N).*occ_cost;
    end
    
    % warp the second image I2 with the flow (u0, v0) and compute the
    % correlation/census/intensity transform C2w of the warped image; also computes the
    % derivatives C2wx and C2wy; this implies two additional warpings for 3 stencils
    [C2w, C2wx, C2wy] = compute_X_transform_and_derivatives_warp(I2, u0, v0, stencils, step_size, st);
    
    b = 0.5; % blending factor of the spatial derivarives
    Cx = b*C2wx + (1-b)*C1x;
    Cy = b*C2wy + (1-b)*C1y;
    
    Ct = C2w - C1; % the temporal derivatives
    
    % boundary handling (relies on the matlab function isnan)
    m1 = isnan(Cx);
    m2 = isnan(Cy);
    m3 = isnan(Ct);
    m = m1 | m2 | m3;
    Cx(m) = 0; Cy(m) = 0; Ct(m) = 0;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % find the solution of the convex problem using PPA (proximal-point
    % algorithm)
    u = medfilt2(u, [3 3], 'symmetric');
    v = medfilt2(v, [3 3], 'symmetric');
    
    [u, v, u_, v_, qu, qv] = solving_DualTVL1(u, v, u_, v_, qu, qv, u0, v0, ...
        Cx, Cy, Ct, W_bf, Lambdas, st.max_its);
    
    %% Xem thu kq:
    %ux = u(1:5,1:5)
end