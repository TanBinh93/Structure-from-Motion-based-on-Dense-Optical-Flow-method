%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Authors: Tan-Binh Phan, Dinh-Hoan Trinh, Christian Daul, Didier Wolf   %
%  Contact: tan-binh.phan@univ-lorraine.fr                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                   % A simple way to use Dense Optical Flow for determination of HP-Groups (groups of homologous point)
%%
clc
clear all
%% Path of images 
addpath(genpath('.\Dense Optical Flow'));
addpath(genpath('.\Mask'));
image_path = '.\Data';
%% Read images
images = global_readPNG;

% The size of image
[M,N,C] = size(images{1});
% The set of points for each images
Homologous_Points = cell(1,numel(images));
% Object for managing data: the 2D points for each image and matching points between them
vSet = viewSet;
matches = {}; % object for saving the matches between images
%% The parameter for Optical flow and group homologous points determination

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
% Descriptor
Descriptor = 2;
st.lambda = Lambda(Descriptor);
st.D = sprintf('D%01i', Descriptor);
st.pyramid_factor = 0.7;% PyramidF(Descriptor);
% Parameter for determination of homologous points
Tau = 2*M*N/3; epsilon = 0.9;

%% Computing the optical flow forward and backward
% OF forward between each pair of consecutive image: Using function forward_consecutive_OF.m
load('U1.mat');
load('V1.mat');
%OF backward between each pair of consecutive image: Using function backward_consecutive_OF.m
% load('U2.mat');
% load('V2.mat');

%% Determination of reference images ans homologous points between images
% For each image, finding the set of overlapping images with it then the reference images can be determined. 
[Omega_ref,Set_Ovv_ref] = Reference_images(image_path,U1,V1,Tau); % in Reference_images.m file, we have already computed the set of overlapping images for each image
[val, idx] = find(Omega_ref == 1);
if length(idx)>1
    Omega_ref(idx(2):end) = [];
end
% An example for generating 2D points for each reference images
k = 1;
for h = 10:10:M-10
    for j = 10:10:N-10
        OF_points(k,:) = [j h];
        k = k + 1;
    end
end
Homologous_Points{1,Omega_ref(1)} = OF_points;
% Save 2D points of each reference images
vSet = addView(vSet, Omega_ref(1), 'Points',  Homologous_Points{1,Omega_ref(1)});
if length(Omega_ref)>1
    for i = 2:length(Omega_ref)
        Homologous_Points{1,Omega_ref(i)} = Homologous_Points{1,Omega_ref(1)};
        tf1 = hasView(vSet,Omega_ref(i));
        if tf1 == 1
            vSet = updateView(vSet, Omega_ref(i), 'Points',  Homologous_Points{1,Omega_ref(i)});
        else
            vSet = addView(vSet, Omega_ref(i), 'Points',  Homologous_Points{1,Omega_ref(i)});
        end
    end
end

% Determination of homologous points between a reference image I_k^{ref} and  each image I_j belongs to the set of overlapping images with it
for i = 1:length(Omega_ref)
    tempt = Set_Ovv_ref{1,Omega_ref(i)}; 
    for j = 1:length(Set_Ovv_ref{1,Omega_ref(i)})
        % Compute Optical Flow forward
        [flow] = tvFlow_calc(images{Omega_ref(i)}, images{tempt(j)}, st);
        u1 = flow(:, :, 1); v1 = flow(:, :, 2);
        % Compute optical Flow backward
        [flow] = tvFlow_calc(images{tempt(j)}, images{Omega_ref(i)}, st);
        u2 = flow(:, :, 1); v2 = flow(:, :, 2);
        Mask_sr = Mask_SR(images{Omega_ref(i)}, images{tempt(j)}); Mask_inacc  = Mask_inac(M,N,u1,v1,u2,v2, epsilon);
%         We also can crop the two sub-images of overlapping regions extracted from I_k^{ref} and I_j and then determine the homologous points between them. 
%         [I1_crop,I2_crop,L,vector_movv] = Crop_Ovverlapping(image_path,U1,V1,Omega_ref(i),tempt(j),numel(images));
%         [flow] = tvFlow_calc(I1_crop, I2_crop, st);
%         u1 = flow(:, :, 1); v1 = flow(:, :, 2);
%         [flow] = tvFlow_calc(I2_crop, I1_crop, st);
%         u2 = flow(:, :, 1); v2 = flow(:, :, 2); [M1,N1,C1] = size(I1_crop);
%         Mask_sr = Mask_SR(I1_crop, I2_crop); Mask_inacc  = Mask_inac(M1,N1,u1,v1,u2,v2, epsilon);
        points1 = Homologous_Points{1,Omega_ref(i)}; tempt1 = []; OFmatch1 = [];
        % OFmatch1 is the 2D points of reference image i that satisfied the masks of inaccurate and SR, tempt1 includes the corresponding points of OFmatch1 in image tempt(j)
        for k = 1:length(points1)
            if (Mask_inacc(round( points1(k,2)),round(points1(k,1))) == 1) && (Mask_sr(round( points1(k,2)),round(points1(k,1))) >= 1)
                a = points1(k,:) + [u1(round(points1(k,2)),round(points1(k,1))) v1(round(points1(k,2)),round(points1(k,1)))];
                OFmatch1 = [OFmatch1;points1(k,:)]; tempt1 = [tempt1;a];
            end
        end
        Homologous_Points{1,tempt(j)} = [Homologous_Points{1,tempt(j)};tempt1];
        % Save the homologous points for each image 
        if isempty(OFmatch1) ~= 1
            tf1 = hasView(vSet,tempt(j));
            if tf1 == 1
                vSet = updateView(vSet, tempt(j), 'Points',  Homologous_Points{1,tempt(j)});
            else
                vSet = addView(vSet, tempt(j), 'Points',  Homologous_Points{1,tempt(j)});
            end
            % Find the index of matches
            [Lia,Locb] = ismember(OFmatch1,Homologous_Points{1,Omega_ref(i)},'rows');
            [Lia1,Locb2] = ismember(tempt1,Homologous_Points{1,tempt(j)},'rows');
            % The index of matches between Omega_ref(i) and tempt(j)
            matches{Omega_ref(i),tempt(j)} = [Locb Locb2];
        else
            tempt(j) = NaN;
        end
    end
end

%% Determination of homologous point groups (HP-Groups)
for i = 1:length(Omega_ref)
    tempt = Set_Ovv_ref{1,Omega_ref(i)};
    for j = 1:length(Set_Ovv_ref{1,Omega_ref(i)})
        if ~isempty(matches{Omega_ref(i),tempt(j)})
            tf = hasConnection(vSet,Omega_ref(i),tempt(j));
            if tf == 1
                vSet = updateConnection(vSet, Omega_ref(i), tempt(j), 'Matches', matches{Omega_ref(i),tempt(j)});
            else
                vSet = addConnection(vSet, Omega_ref(i), tempt(j), 'Matches', matches{Omega_ref(i),tempt(j)});
            end
        end
    end
end
% Point groups determination
HP_groups = findTracks(vSet);
%% Visualization a group
% num = 3000;
% for i = 1:length(HP_groups(num).ViewIds)
%     subplot(3,3,i)
%     imshow(images{HP_groups(num).ViewIds(i)});
%     hold on
%     plot(HP_groups(1,num).Points(i,1),HP_groups(1,num).Points(i,2), 'r+', 'LineWidth', 2, 'MarkerSize', 10);
% end