%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Authors: Tan-Binh Phan, Dinh-Hoan Trinh, Christian Daul, Didier Wolf   %
%  Contact: tan-binh.phan@univ-lorraine.fr                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mm] = Mask_SR(Im1, Im2)
%  Im1 = imread(Im1);
%  Im2 = imread(Im2);

% [M,N,~] = size(Im1);
R1 = Im1(:,:,1);
G1 = Im1(:,:,2);
B1 = Im1(:,:,3);

R2 = Im2(:,:,1);
G2 = Im2(:,:,2);
B2 = Im2(:,:,3);
 
% imshow(Im1);
 
Id1 = (B1>10);
se1 = strel('square',3);
Id11 = imdilate(Id1,se1);
 
% figure, imshow(Im1(:,:,3));
% figure, imshow(Id11);

Id2 = (B2>10);
se2 = strel('square',3);
Id22 = imdilate(Id2,se2);
 
% figure, imshow(Im2(:,:,3));
% figure, imshow(Id22); 

mm  = (Id11 + Id22)>=1;


