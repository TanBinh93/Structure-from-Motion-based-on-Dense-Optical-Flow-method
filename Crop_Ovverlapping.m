%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Authors: Tan-Binh Phan, Dinh-Hoan Trinh, Christian Daul, Didier Wolf   %
%  Contact: tan-binh.phan@univ-lorraine.fr                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Objective: For each I_j belongs to the set of overlapping images with S_k^{ref}, cropping two sub-images on the overlapping region of I_k^{ref} and I_j
% Input:     image_path is the path of images
%            U1,V1: optical flow forward (computed by forward_consecutive_OF.m)
%            Id1: a reference image
%            Id2: an image belongs to the set of tau-overlapped images with Id1 
%            Num: the number of images
% Output:    The two sub-images on the overlapping region of Id1 and Id2
%            L is matrix contains the central point of each image.
%            vector_movv: the vector movement between image Id1 and image  Id2
function [I1_crop,I2_crop,L,vector_movv] = Crop_Ovverlapping(image_path,U1,V1,Id1,Id2,Num)
imageDir=fullfile(image_path);
imds = imageDatastore(imageDir);
[M,N,C] = size(imread(imds.Files{1}));
% Num: the number of images
%%  vector contain the point center for each image
L = zeros(2,Num); 
for i = 1:(Num-1)
    u = U1(:,:,i);
    v = V1(:,:,i); 
    u_f = u(floor(M/2));
    v_f = v(floor(N/2));
    L(1,i+1)=u_f;
    L(2,i+1)=v_f;  
end

if Id1 > Id2
    array_row = L(1,Id2:Id1);
    array_column =L(2,Id2:Id1);
    vector_row = sum(array_row);
    vector_column = sum(array_column);
    vector_movv = [vector_row vector_column];
    I1 = imread(imds.Files{Id1}); % read image Id1
    if L(1,Id1) > L(1,Id2) && (L(2,Id1)>L(2,Id2))
         I1_crop = imcrop(I1,[(floor(abs(vector_row))+1) (floor(abs(vector_column))+1) N M]);
    elseif L(1,Id1) > L(1,Id2) && (L(2,Id1)<L(2,Id2))
         I1_crop = imcrop(I1,[(floor(abs(vector_row))+1) 0 N (M-floor(abs(vector_column))+1)]);
    elseif L(1,Id1) < L(1,Id2) && (L(2,Id1)>L(2,Id2))
         I1_crop = imcrop(I1,[0 (floor(abs(vector_column))+1) (N-floor(abs(vector_row))) M]);
    else
         I1_crop = imcrop(I1,[0 0 (N-floor(abs(vector_row))) (M-floor(abs(vector_column))+1)]);
    end
%     thisFileName1 =  [sprintf('Overlap%1d',Id1) '.png'];
%     fullFileName = fullfile(pwd, thisFileName1);
%     imwrite(I1_crop, fullFileName);
    I2 = imread(imds.Files{Id2}); % read image Id1
    if L(1,Id1) > L(1,Id2) && (L(2,Id1)>L(2,Id2))
         I2_crop = imcrop(I2,[0 0 (N-floor(abs(vector_row))) (M-floor(abs(vector_column)))]);
    elseif L(1,Id1) > L(1,Id2) && (L(2,Id1)<L(2,Id2))
         I2_crop = imcrop(I2,[0 floor((abs(vector_column))) (N-floor(abs(vector_row))) M]);
    elseif L(1,Id1) < L(1,Id2) && (L(2,Id1)>L(2,Id2))
         I2_crop = imcrop(I2,[floor(abs(vector_row)+1) 0 N (M-floor(((abs(vector_column)))))]);
    else
         I2_crop = imcrop(I2,[floor(abs(vector_row)+1) floor(((abs(vector_column)))) N M]);
    end
%     thisFileName2 =  [sprintf('Overlap%1d',Id2) '.png'];
%     fullFileName = fullfile(pwd, thisFileName2);
%     imwrite(I2_crop, fullFileName);
else
    array_row = L(1,Id1:Id2);
    array_column =L(2,Id1:Id2);
    vector_row = sum(array_row);
    vector_column = sum(array_column);
    vector_movv = [vector_row vector_column];
    I1 = imread(imds.Files{Id1}); % read image Id1
    if L(1,Id1) > L(1,Id2) && (L(2,Id1)>L(2,Id2))
         I1_crop = imcrop(I1,[(floor(abs(vector_row))+1) (floor(abs(vector_column))+1) N M]);
    elseif L(1,Id1) > L(1,Id2) && (L(2,Id1)<L(2,Id2))
         I1_crop = imcrop(I1,[floor(abs(vector_row))+1 0 N (M-floor(abs(vector_column))+1)]);
    elseif L(1,Id1) < L(1,Id2) && (L(2,Id1)>L(2,Id2))
         I1_crop = imcrop(I1,[0 (floor(abs(vector_column))+1) (N-floor(abs(vector_row))) M]);
    else
          I1_crop = imcrop(I1,[0 0 (N-floor(abs(vector_row))) (M-floor(abs(vector_column))+1)]);
    end
%     thisFileName1 =  [sprintf('Overlap%1d',Id1) '.png'];
%     fullFileName = fullfile(pwd, thisFileName1);
%     imwrite(I1_crop, fullFileName);
    I2 = imread(imds.Files{Id2}); % read image Id1
    if L(1,Id1) > L(1,Id2) && (L(2,Id1)>L(2,Id2))
         I2_crop = imcrop(I2,[0 0 (N-floor(abs(vector_row))) ((M-floor(abs(vector_column))))]);
    elseif L(1,Id1) > L(1,Id2) && (L(2,Id1)<L(2,Id2))
         I2_crop = imcrop(I2,[0 floor((abs(vector_column))) (N-floor(abs(vector_row))) M]);
    elseif L(1,Id1) < L(1,Id2) && (L(2,Id1)>L(2,Id2))
         I2_crop = imcrop(I2,[floor(abs(vector_row)+1) 0 N (M-floor(((abs(vector_column)))))]);
    else
         I2_crop = imcrop(I2,[floor(abs(vector_row)+1) floor(((abs(vector_column)))) N M]);
    end
%     thisFileName2 =  [sprintf('Overlap%1d',Id2) '.png'];
%     fullFileName = fullfile(pwd, thisFileName2);
%     imwrite(I2_crop, fullFileName);
end