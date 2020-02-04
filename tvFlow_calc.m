%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Authors: Tan-Binh Phan, Dinh-Hoan Trinh, Christian Daul, Didier Wolf   %
%  Contact: tan-binh.phan@univ-lorraine.fr                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Occ_mask is a binary image {0 1}, where 1 is mean that there are no correspondence points
%(occlusion)
function [flow, Occ_mask] = tvFlow_calc(I1, I2, st)

M = size(I1, 1); N = size(I1, 2);
% computes the maximum number of pyramid levels; the coarsest image should
% have a width or height around 10
pyramid_levels = min(...
    ceil(log(10/M)/log(st.pyramid_factor)), ...
    ceil(log(10/N)/log(st.pyramid_factor)))
%pyramid_levels = 5;

%% buid image pyramids
I1_gray = rgb2gray(I1);
I2_gray = rgb2gray(I2);

pyrI1 = cell(pyramid_levels, 1);
pyrI2 = cell(pyramid_levels, 1);
pyrI1_for_bf = cell(pyramid_levels, 1);

pyrI1{1} = I1_gray;
pyrI2{1} = I2_gray;
pyrI1_for_bf{1} = I1;

% build the pyramids
for i = 2:pyramid_levels
    pyrI1{i} = imresize(I1_gray, (st.pyramid_factor)^(i-1), 'bicubic');%st.downsample_method);
    pyrI2{i} = imresize(I2_gray, (st.pyramid_factor)^(i-1), 'bicubic');% st.downsample_method);
    
    % separate downsampling for the pyramid used for the bilateral coefficients
    % use or not antialiasing for the current level
    if i >= st.antialiasing_start_level
        antialiasing = true;
    else
        antialiasing = false;
    end
    pyrI1_for_bf{i} = imresize(I1, (st.pyramid_factor)^(i-1), 'bicubic', 'Antialiasing', antialiasing);
end
%%
% start coarse to fine processing
for level = pyramid_levels:-1:1
    level
    
    M = size(pyrI1{level}, 1);
    N = size(pyrI1{level}, 2);
    
    if level == pyramid_levels % if the coarsest level
        % initialization of the flow
        u = zeros(M,N);
        v = zeros(M,N);
        u_ = zeros(M,N);
        v_ = zeros(M,N);
    else % if not the coarsest level, upsample the flow from the previous level to the current level
        rescale_factor_u = N/size(pyrI1{level+1}, 2); % rescaling factor along width
        rescale_factor_v = M/size(pyrI1{level+1}, 1); % rescaling factor along height
        
        % prolongate to finer grid
        u = imresize(u, [M N], st.upsample_method)*rescale_factor_u; % u tu dong ghi de len
        v = imresize(v, [M N], st.upsample_method)*rescale_factor_v;
        
        u_ = imresize(u_, [M N], st.upsample_method)*rescale_factor_u;
        v_ = imresize(v_, [M N], st.upsample_method)*rescale_factor_v;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % solve the flow on the current level
    I1_level = double(pyrI1{level})/255;
    I2_level = double(pyrI2{level})/255;
    I_bf_level = double(pyrI1_for_bf{level})/255;
%     I1_level = pyrI1{level};
%     I2_level = pyrI2{level};
%     I_bf_level = pyrI1_for_bf{level};
    
    [u, v, u_, v_] = procOneScale(u, v, u_, v_, I1_level, I2_level, I_bf_level, st, level);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
end

% store the final flow
flow = zeros(M,N,2);
flow(:,:,1) = u;
flow(:,:,2) = v;
[occ, xx] = occlusions_map_mex(u,v);
occ2 = min(max(0,occ-1),1);
occ_cost = 1 - occ2;

Occ_mask = find(occ_cost < 0.1);
end