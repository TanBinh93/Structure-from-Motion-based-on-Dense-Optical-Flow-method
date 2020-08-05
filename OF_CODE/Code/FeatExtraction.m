% Author: Dr Dinh Hoan TRINH, 
% This descriptor is created based on the general form of illumination invariant descriptors 
% given in the paper: D.H. Trinh and C. Daul, "On Illumination-Invariant Variational Optical
% Flow for Weakly Textured Scenes," Computer Vision and Image Understanding 179, 1-18, 2019
function vectorF = FeatExtraction(I)
% Compute descriptor (vectorF(i,j,:)) for all pixels (i,j)

[m,n] = size(I);

vectorF = zeros(m,n,12);
K1 = [-1 -1 -1; 0 3 0; 0 0 0]; K2 = [0 -1 -1; 0 3 -1; 0 0 0]; K3 = [0 0 -1; 0 3 -1; 0 0 -1]; K4 = [0 0 0; 0 3 -1; 0 -1 -1];
K5 = [0 0 0; 0 3 0; -1 -1 -1]; K6 = [0 0 0; -1 3 0; -1 -1 0]; K7 = [-1 0 0;-1 3 0; -1 0 0]; K8 = [-1 -1 0; -1 3 0; 0 0 0];
K9 = [0 -1 0; -1 3 -1; 0 0 0]; K10 = [0 -1 0; 0 3 -1; 0 -1 0]; K11 = [0 0 0; -1 3 -1; 0 -1 0]; K12 = [0 -1 0; -1 3 0; 0 -1 0];

F(:,:,1) = imfilter(I,K1); F(:,:,2) = imfilter(I,K2); F(:,:,3) = imfilter(I,K3); F(:,:,4) = imfilter(I,K4);
F(:,:,5) = imfilter(I,K5); F(:,:,6) = imfilter(I,K6); F(:,:,7) = imfilter(I,K7); F(:,:,8) = imfilter(I,K8);
F(:,:,9) = imfilter(I,K9); F(:,:,10) = imfilter(I,K10); F(:,:,11) = imfilter(I,K11); F(:,:,12) = imfilter(I,K12);

Nor = F(:,:,1).^2 + F(:,:,2).^2 + F(:,:,3).^2 + F(:,:,4).^2 + F(:,:,5).^2 + F(:,:,6).^2 + F(:,:,7).^2 + F(:,:,8).^2 + F(:,:,9).^2 + F(:,:,10).^2 + F(:,:,11).^2 + F(:,:,12).^2;
Nor = sqrt(Nor) + 1e-09;
for k = 1:12
	vectorF(:,:,k) = F(:,:,k)./Nor;
end








