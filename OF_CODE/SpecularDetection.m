close all
clear all

Im = imread('frame_gastro.png');
[M,N,~] = size(Im);
R = Im(:,:,1);
G = Im(:,:,2);
B = Im(:,:,3);
I = zeros(M,N);
S = zeros(M,N);
for i = 1:M
    for j = 1:N
        I(i,j) = min([R(i,j),G(i,j),B(i,j)])/max([R(i,j),G(i,j),B(i,j)]);
    end
end

rgb(:,:,1) = I.*double(Im(:,:,1));
rgb(:,:,2) = I.*double(Im(:,:,2));
rgb(:,:,3) = I.*double(Im(:,:,3));
XYZ = rgb2xyz(rgb);
y = XYZ(:,:,2)./(XYZ(:,:,1) + XYZ(:,:,2) + XYZ(:,:,3));
Id1 = XYZ(:,:,2) > y;
se = strel('square',7);
Id2 = imdilate(Id1,se);
imshow(Im);
figure, imshow(Id1),title('Mask original');
figure, imshow(Id2),title('Mask with dilation');
