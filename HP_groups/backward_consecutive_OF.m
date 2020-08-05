%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Authors: Tan-Binh Phan, Dinh-Hoan Trinh, Christian Daul, Didier Wolf   %
%  Contact: tan-binh.phan@univ-lorraine.fr                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  Objective: Computing backward optical flow  for each pair of consecutive images 
%   Input:     + image path: full path of images
%              + format_images: png, jpg, tif, etc. 
%   Output:    Matrices U2 and V2 contain the optical flow computation for backward consecutive images.

function [U2,V2] = backward_consecutive_OF(image_path,format_images)

%% Input images and read images 
images = Read_images(image_path,format_images);
[M,N,C] = size(images{1});
%%
U2 = zeros(M,N,numel(images)-1);
V2 = zeros(M,N,numel(images)-1); 
for i = numel(images):-1:2
    %    Undistort the current image.
    %    I = undistortImage(images{i}, cameraParams);
    [flow] = tvFlow_calc(images{i}, images{i-1});
    u = flow(:, :, 1); U2(:,:,i-1) = u;
    v = flow(:, :, 2); V2(:,:,i-1) = v;
end
save U2.mat U2
save V2.mat V2