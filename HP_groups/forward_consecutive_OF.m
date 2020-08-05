%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Authors: Tan-Binh Phan, Dinh-Hoan Trinh, Christian Daul, Didier Wolf   %
%  Contact: tan-binh.phan@univ-lorraine.fr                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  Objective: Computing forward optical flow forward for each pair of consecutive images 
%  Input:     + image path: full path of images
%             + format_images: png, jpg, tif, etc. 
%  Output:    Matrices U1 and V1 contain the optical flow computation for forward consecutive images. 

function [U1,V1] = forward_consecutive_OF(image_path,format_images)

%% Input images and read images 
images = Read_images(image_path,format_images);
[M,N,C] = size(images{1});
%%
U1 = zeros(M,N,numel(images)-1);
V1 = zeros(M,N,numel(images)-1); 
for i = 1:(numel(images)-1)
    %    Undistort the current image.
    %    I = undistortImage(images{i}, cameraParams);
    [flow] = tvFlow_calc(images{i}, images{i+1});
    u = flow(:, :, 1); U1(:,:,i) = u;
    v = flow(:, :, 2); V1(:,:,i) = v;    
end
save U1.mat U1
save V1.mat V1