%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Authors: Tan-Binh Phan, Dinh-Hoan Trinh, Christian Daul, Didier Wolf   %
%  Contact: tan-binh.phan@univ-lorraine.fr                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Omega_ref,Set_Ovv_ref] = Reference_images(image_path,U1,V1,Tau)
%% Read images
% image_path: path include images;
% U1, V1: optical flow forward
% Tau : Tau threshold, can be set to 2*W*H/3 where W*H be the size of image
imageDir=fullfile(image_path);
imds = imageDatastore(imageDir);
%% Save the data
% G={S_i}, 1<=i<=n with n is the number of images, S_i is the set of tau-
% overlapped images with image I_i
G = cell(1,numel(imds.Files)); 
Omega_ref = []; % The set of reference images
NB = []; % The number element of  each set S_i
Set_Ovv_ref = {}; % Set_Ovv_ref consists of the set of overlapping images with each reference images
%% Step 1: Determination of each S_i
for i = 1:numel(imds.Files)
    index_image_k = i;
    [S_k] = find_overlapping_regions(image_path,Tau,index_image_k,U1,V1);
    NB(index_image_k) = numel(S_k);
    G{1,index_image_k} = S_k;
end
%% Step 2: Determination of reference images
Set  = NB; check = ones(1,numel(imds.Files)); 
% Total = linspace(1,numel(imds.Files),1)
for j = 1:numel(imds.Files)
    [M,P] = max(Set); % Determination of maximum element of S_i in G
    tempt = P; % P is the index of image I_P
    Omega_ref = [Omega_ref;tempt]; % Determination of reference image k
    Set_Ovv_ref{1,tempt} = G{1,tempt};
    for k = 1:numel(G{1,tempt})
        Set(G{1,tempt}(k))=1; % Remove S_i in G with i is the index of I_i belong to S_k by put each element of G equal 1
        Set(tempt) =1;
    end
    if (isequal(Set,check)==1)
        break
    end
end
