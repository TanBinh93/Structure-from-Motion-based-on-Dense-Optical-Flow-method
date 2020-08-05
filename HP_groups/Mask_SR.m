%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Authors: Tan-Binh Phan, Dinh-Hoan Trinh, Christian Daul, Didier Wolf   %
%  Contact: tan-binh.phan@univ-lorraine.fr                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Objective: Determine the regions between two images that are not afftected by the specular reflections.
% Input:  + Im1, Im2: two images
% Output: + mm: the regions which are not affected by the specular reflections.
function [mm] = Mask_SR(Im1, Im2)
M1 = Mask_SR_detector(Im1);
M2 = Mask_SR_detector(Im2);

mm  = (M1 + M2)>=1;


