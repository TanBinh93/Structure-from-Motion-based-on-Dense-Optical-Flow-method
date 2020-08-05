%%
% Written by Dr. Dinh Hoan TRINH
% Email: dinh-hoan.trinh@univ-lorraine.fr
%------------------------------------------ 
function [flow] = tvFlow_calc(I1, I2)
Parameter_setting;
I1 = double(I1)/255;
I2 = double(I2)/255;
M = size(I1, 1); N = size(I1, 2);
% computes the maximum number of pyramid levels; the coarsest image should
% have a width or height around 10
pyramid_levels = min(...
    ceil(log(10/M)/log(para.pyramid_factor)), ...
    ceil(log(10/N)/log(para.pyramid_factor)));

%% buid image pyramids
if size(size(I1),2)>2
    I1_gray  = 0.2989*I1(:, :, 1) + 0.5870*I1(:, :, 2) + 0.1140*I1(:, :, 3);
    I2_gray = 0.2989*I2(:, :, 1) + 0.5870*I2(:, :, 2) + 0.1140*I2(:, :, 3);
else
    I1_gray = I1; I2_gray = I2;
end

pyrI1 = cell(pyramid_levels, 1);
pyrI2 = cell(pyramid_levels, 1);
pyrI1_for_bf = cell(pyramid_levels, 1);

pyrI1{1} = I1_gray;
pyrI2{1} = I2_gray;
pyrI1_for_bf{1} = I1;

% build the pyramids
for i = 2:pyramid_levels
    pyrI1{i} = imresize(I1_gray, (para.pyramid_factor)^(i-1), 'bicubic');
    pyrI2{i} = imresize(I2_gray, (para.pyramid_factor)^(i-1), 'bicubic');
    
    % separate downsampling for the pyramid used for the regularization weights
    % use or not antialiasing for the current level
    if i >= para.antialiasing_start_level
        antialiasing = true;
    else
        antialiasing = false;
    end
    pyrI1_for_bf{i} = imresize(I1, (para.pyramid_factor)^(i-1), 'bicubic', 'Antialiasing', antialiasing);
end
%%
% start coarse to fine processing
for level = pyramid_levels:-1:1
    
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
        u = imresize(u, [M N], para.upsample_method)*rescale_factor_u; % u tu dong ghi de len
        v = imresize(v, [M N], para.upsample_method)*rescale_factor_v;
        
        u_ = imresize(u_, [M N], para.upsample_method)*rescale_factor_u;
        v_ = imresize(v_, [M N], para.upsample_method)*rescale_factor_v;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % solve the flow on the current level
    I1_level = pyrI1{level};
    I2_level = pyrI2{level};
    I_bf_level = pyrI1_for_bf{level};
    
    [u, v, u_, v_] = procOneScale(u, v, u_, v_, I1_level, I2_level, I_bf_level, para, level);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
end

% store the final flow
flow = zeros(M,N,2);
flow(:,:,1) = u;
flow(:,:,2) = v;
end