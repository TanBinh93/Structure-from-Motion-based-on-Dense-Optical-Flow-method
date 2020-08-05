% Author: Dr Dinh Hoan TRINH, CRAN, University of Lorraine, France.
%% Parameters:
para.lambda = 15; % the weight of the data term
para.pyramid_factor = 0.7; % pyramide scale
para.gamma1 = 3; % parameter gamma1 in reglarization term (for distance) 
para.gamma2 = 5; % parameter gamma1 in reglarization term (for color)
%% other settings:
para.nx = 5; para.ny = para.nx; % the size of non-local propagation window
% 
para.downsample_method = 'bilinear'; % the downsampling method used to build the pyramids
para.upsample_method = 'bicubic'; % method for upsampling the flow
para.downsample_method_for_bf = 'bilinear'; % the downsampling method for the pyramid used to compute the bilateral weights
para.antialiasing_start_level = 3; % perform antialiasing for all the levels higher or equal than the given level; for the other levels do not use antialiasing
% warping settings
para.warps = 5; % the numbers of warps per level
para.warping_method = 'bicubic';
para.max_its = 40; % the number of iterations per warp






