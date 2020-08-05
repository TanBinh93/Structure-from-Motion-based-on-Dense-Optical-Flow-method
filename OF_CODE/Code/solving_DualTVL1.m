%% minimize the function E(w) = lambda * Ed(w) + F(Kw); w = (u, v)
function [u, v, u_, v_, qu, qv] = solving_DualTVL1(u, v, u_, v_, qu, qv, u0, v0, ...
    Cx, Cy, Ct, W_bf, lambdas, maxits)

nx = size(qu, 3); ny = size(qv, 4);

% stepwidth
tau = 2/nx/ny;
eta = 2/nx/ny;
epsilon = 0.1;

M = size(Cx, 1);
N = size(Cx, 2);
dx = size(Cx, 3);
dy = size(Cx, 4);

C0 = zeros(size(Cx));
s_Cx_Cx = zeros(M, N);
s_Cx_Cy = zeros(M, N);
s_Cy_Cy = zeros(M, N);
s_Cx_C0 = zeros(M, N);
s_Cy_C0 = zeros(M, N);

% Each pixel contributes to the final energy; the data energy corresponding to
% the pixel (i, j) is Ed(w; i,j) = lambda * sum_region_of_i_j { (u-u0)*Cx + (v-v0 )*Cy + Ct)^2 }
% for each pixel, sums up the terms after derivation w.r.t. u and v
%size(C0)

for i = 1:dx
    C0(:, :, i) = Ct(:, :, i) - u0.*Cx(:, :, i) - v0.*Cy(:, :, i);
    s_Cx_Cx = s_Cx_Cx + Cx(:, :, i).*Cx(:, :, i)/dx;
    s_Cx_Cy = s_Cx_Cy + Cx(:, :, i).*Cy(:, :, i)/dx;
    s_Cy_Cy = s_Cy_Cy + Cy(:, :, i).*Cy(:, :, i)/dx;
    
    s_Cx_C0 = s_Cx_C0 + Cx(:, :, i).*C0(:, :, i)/dx;
    s_Cy_C0 = s_Cy_C0 + Cy(:, :, i).*C0(:, :, i)/dx;
end

L_s_xx = lambdas .* s_Cx_Cx;
L_s_xy = lambdas .* s_Cx_Cy;
L_s_yy = lambdas .* s_Cy_Cy;

L_s_x0 = lambdas .* s_Cx_C0;
L_s_y0 = lambdas .* s_Cy_C0;

% the matrix M
m11 = 1/tau + 2 * L_s_xx;
m12 = 2 * L_s_xy;
m21 = m12;
m22 = 1/tau + 2 * L_s_yy;

% the inverse of the matrix M; N = inv(M);
delta_M = m11.*m22 - m12.*m21;
n11 = m22./delta_M;
n12 = - m12./delta_M;
n22 = m11./delta_M;

K2_s_qu = zeros(M, N);
K2_s_qv = zeros(M, N);

K2_u_ = zeros(size(W_bf));
K2_v_ = zeros(size(W_bf));

%% primal-dual optimization
for k = 1:maxits
    %% dual step
    % compute the linear operator Kw: <Kw, q> = <w, K'q>
    linear_operator(K2_u_, u_);
    linear_operator(K2_v_, v_);
    % update dual variable
    qu = (qu/eta + K2_u_)./(1/eta + epsilon./W_bf);
    qv = (qv/eta + K2_v_)./(1/eta + epsilon./W_bf);
    % reprojection on the feasible set
    qu = qu./max(abs(qu), W_bf) .* W_bf;
    qv = qv./max(abs(qv), W_bf) .* W_bf;
    
    %% primal step
    % compute the adjoint operator K'q: <Kw, q> = <q, K'q>
    adjoint_linear_operator(K2_s_qu, qu);
    adjoint_linear_operator(K2_s_qv, qv);
    
    % update primal variable
    % pre-translation of the linear term
    zu = u - tau * K2_s_qu;
    zv = v - tau * K2_s_qv;
    % step 2
    % computes b vector
    bu = zu/tau;
    bv = zv/tau;
    bu = bu - 2 * L_s_x0;
    bv = bv - 2 * L_s_y0;
    
    % save previous w
    un = u;
    vn = v;
    
    % update primal variable
    u = n11 .* bu + n12 .* bv;
    v = n12 .* bu + n22 .* bv;
    
    % check for outliers
    ids = (abs(u) > 250) | (abs(v) > 250);
    u(ids) = un(ids);
    v(ids) = vn(ids);        
    
    % extrapolation of the primal variable; extra gradient step
    u_ = u + 1*(u - un);
    v_ = v + 1*(v - vn);    
end
end