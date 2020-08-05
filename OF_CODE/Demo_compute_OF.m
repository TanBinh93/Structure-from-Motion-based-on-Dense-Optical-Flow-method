%%
% Written by Dr. Dinh Hoan TRINH
% Email: dinh-hoan.trinh@univ-lorraine.fr
%%
clc
close all;
clear all;

addpath('./Code');
addpath('./Flow_show');

%% Read images:
I1 = imread('I_frame10.png');
I2 = imread('I_frame11.png');
subplot(1,2,1), imshow(I1), title('Source image');
subplot(1,2,2), imshow(I2), title('Target image');

%% read the ground-truth flow
floPath = 'flow10.flo';
realFlow = readFlowFile(floPath);
tu = realFlow(:, :, 1);
tv = realFlow(:, :, 2);
tic;

%% call main routine
[flow, Occ_mask] = tvFlow_calc(I1, I2);
%[flow] = coarse_to_fine(I1, I2, para);
u = flow(:, :, 1);
v = flow(:, :, 2);

%% evalutate the correctness of the computed flow
% compute the mean end-point error (mepe) and the mean angular error (mang)
UNKNOWN_FLOW_THRESH = 1e9;
[mang, mepe] = flowError(tu, tv, u, v, 0, 0.0, UNKNOWN_FLOW_THRESH);
disp(['Mean end-point error: ', num2str(mepe)]);
disp(['Mean angular error: ', num2str(mang)]);

%% display the flow
%plotFlow(u,v ,I1);
flowImg = uint8(robust_flowToColor(flow));
figure; imshow(flowImg), title('Optical flow');

tg = toc;
disp(['Computational times is ', num2str(tg),' seconds']);
fprintf('\n');