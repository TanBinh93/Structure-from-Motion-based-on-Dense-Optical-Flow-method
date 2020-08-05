%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Authors: Tan-Binh Phan, Dinh-Hoan Trinh, Christian Daul, Didier Wolf   %
%  Contact: tan-binh.phan@univ-lorraine.fr                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Dense Optical Flow for determination of HP-Groups (groups of homologous point)
% Input: the set of images.
% Output : + HP_groups: groups of homologous point. A group contains the views and 2D point on each view. 
%          + Vset: Object for managing data. It includes the set of 2D points on each view, the
%                  homologous points between two views (if they are connected).
%%
clc
clear all
close all
%% Add Paths
path_to_OFcode = 'E:\Code Matlab\OF_CODE';
addpath(path_to_OFcode);% Other way: set path to the OF_CODE folder.

addpath(genpath('.\HP_groups'));
image_path = '.\Data_demo';

% Read the set of images
format_images = '*.png'; 
images = Read_images(image_path,format_images); 
[M,N,C] = size(images{1});

% Parameters for determination of homologous points
% pg.tau: a threshold for overlapped region.
% pg.epsilon: a threshold value ensures an accurate pixel correspondence.
% pg.h: a grid size.
pg.tau = 2*M*N/3; pg.epsilon = 0.9; pg.h = 10;

%% Groups of homologous point determination
[HP_groups,vSet] = Generate_HP(image_path,format_images,pg);

%% Visualization a group
% num = 1000;
% for i = 1:length(HP_groups(num).ViewIds)
%     subplot(3,3,i)
%     imshow(images{HP_groups(num).ViewIds(i)});
%     hold on
%     plot(HP_groups(1,num).Points(i,1),HP_groups(1,num).Points(i,2), 'r+', 'LineWidth', 2, 'MarkerSize', 10);
% end