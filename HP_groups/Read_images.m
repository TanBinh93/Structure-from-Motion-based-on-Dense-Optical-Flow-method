% Objective: Read the set of images 
% Input: + myFolder: the folder which contains the set of images
%        + format_images: format_images: png, jpg, tif, etc. 
% Output: x: is a cell that contains the images have read.
% This function use natsort.m and natsortfiles.m
% ------------------------------------------------------------
function x = Read_images(myFolder,format_images)
format bank;

% myFolder = uigetdir(pwd,'Choose Data folder...'); '*.png'
filePattern = fullfile(myFolder, format_images);
matFiles = dir(filePattern);

for i = 1:length(matFiles)
    temp{i} = matFiles(i).name;
end

temp = natsortfiles(temp);

for i = 1:length(matFiles)
    matFiles(i).name = temp{i};
end

for i = 1:length(matFiles)
    path = [myFolder '\' matFiles(i).name];
    img_temp{i} = imread(path);
    fprintf(1,'Loading: %s\n',matFiles(i).name)
    
%    frame =  img_temp{i};
    
%     figure;
%     image(frame,'CDataMapping','scaled')
%     title(matFiles(i).name);
%     colormap(jet)
%     colorbar
end
clearvars -except img_temp
x = img_temp;
pause(0.5);
%clc;
end