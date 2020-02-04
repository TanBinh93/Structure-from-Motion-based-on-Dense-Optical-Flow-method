%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Authors: Tan-Binh Phan, Dinh-Hoan Trinh, Christian Daul, Didier Wolf   %
%  Contact: tan-binh.phan@univ-lorraine.fr                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Computing optical flow forward for each pair of consecutive images 
clc
close all;
clear all;
%% Input images and read images 
addpath(genpath('.\Dense Optical Flow'));
image_path = '.\Data';
imageDir=fullfile(image_path);
imds = imageDatastore(imageDir);
for i = 1:numel(imds.Files)
    images{i} = readimage(imds, i);
end
[M,N,C] = size(images{1});
%% Setting parameters:
PyramidF = [0.9 0.7 0.9 0.9 0.9 0.9 0.7 0.8 0.5 0.9];
Lambda = [11 50 60 30 30 1.3 35 10 12 75];

st.dx = 3; st.dy = st.dx; % the size of the data window (the size of the correlation window, the size of the census window etc)
st.nx = 5; st.ny = st.nx; % the size of non-local propagation window
% rescalling settings
st.old_auto_level = false;
st.unEqualSampling = true;
st.downsample_method = 'bilinear'; % the downsampling method used to build the pyramids
st.upsample_method = 'bilinear'; % method for upsampling the flow
st.downsample_method_for_bf = 'bilinear'; % the downsampling method for the pyramid used to compute the bilateral weights
st.antialiasing_start_level = 3; % perform antialiasing for all the levels higher or equal than the given level; for the other levels do not use antialiasing
% warping settings
st.warps = 5; % the numbers of warps per level
st.warping_method = 'bicubic';
% numerical scheme's settings
st.max_its = 35; % the number of equation iterations per warp
%%
Descriptor = 2;
st.lambda = Lambda(Descriptor);
st.D = sprintf('D%01i', Descriptor);
st.pyramid_factor = 0.7;% PyramidF(Descriptor);
%%
U1 = zeros(M,N,numel(images)-1);
V1 = zeros(M,N,numel(images)-1); 
for i = 1:(numel(images)-1)
    %    Undistort the current image.
    %    I = undistortImage(images{i}, cameraParams);
    [flow] = tvFlow_calc(images{i}, images{i+1}, st);
    u = flow(:, :, 1); U1(:,:,i) = u;
    v = flow(:, :, 2); V1(:,:,i) = v;    
end
save U1.mat U1
save V1.mat V1