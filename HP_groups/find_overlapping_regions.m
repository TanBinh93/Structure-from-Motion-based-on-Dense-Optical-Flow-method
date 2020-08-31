%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Authors: Tan-Binh Phan, Dinh-Hoan Trinh, Christian Daul, Didier Wolf   %
%  Contact: tan-binh.phan@univ-lorraine.fr                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Objective : Given an arbitrary image, the aim of this function is to determine the set of overlapping images with it.
%      Input : + image_path: full path of images.
%              + Tau: a threshold for overlapped region.
%              + index_image_k: an arbitrary image.
%              + U, V: forward optical flow  for each pair of consecutive
%                      images (computed by forward_consecutive_OF.m).
%              + format_images: png, jpg, tif, etc. 
%
%      Output: + S: the set of overlapping images with an input image.
      
function [S] = find_overlapping_regions(image_path,Tau,index_image_k,U,V,format_images)
images = Read_images(image_path,format_images);
[M,N,C] = size(images{1});
%%
L = numel(images); S=[];
vector=zeros(2,L); % vector contain the coordinate of center point
for i = 1:L-1
     u =  U(:,:,i);
     v =  V(:,:,i);
     u_f = u(floor(M/2));
     v_f = v(floor(N/2));
     vector(1,i+1)=u_f;
     vector(2,i+1)=v_f;    
end

%% MAIN
IMAGE_SET=1:1:numel(images);
% Find the set of images that not contain the image k
[Complementary_set,index_new] = setdiff(IMAGE_SET,index_image_k);
% imds.Files = setdiff(imds.Files,imds.Files(index_image_k));
compute_area = [];
for j = 1 : numel(index_new)
    if index_image_k < index_new(j)
        array_row = vector(1,(index_image_k):(index_new(j)));
        array_column = vector(2,(index_image_k):(index_new(j)));
        vector_row = sum(array_row);
        vector_column = sum(array_column);
        compute_area(j) = (M-abs(vector_column))*(N-abs(vector_row));
        if compute_area(j) >= Tau
            tempt =index_new(j);
            S = [S;tempt];
%             subset(j)= imds.Files(index_new(j));
        end 
    else
        array_row = vector(1,(index_new(j)):(index_image_k));
        array_column = vector(2,(index_new(j)):(index_image_k));
        vector_row = sum(array_row);
        vector_column = sum(array_column);
        compute_area(j) = (M-abs(vector_column))*(N-abs(vector_row));
        if compute_area(j) >= Tau
            tempt =index_new(j);
            S = [S;tempt];
%             subset(j)= imds.Files(index_new(j));
        end 
    end
end

end