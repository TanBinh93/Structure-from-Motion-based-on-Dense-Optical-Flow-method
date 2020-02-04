% Lectura de muestras Lepton X.X
% Version 3.1

% Updates:
    % -------11.07.2019-------------
    % Lectura sï¿½ncrona de datos auxilisado con la funciï¿½n 'natsortfiles'.
    % la licencia de autor se adjunto junto con las funciones en la misma
    % ruta del cï¿½digo.
    
    % Diseï¿½ado como una funciï¿½n para emplearse en futuros cï¿½digos.
    % -------23.01.2020-------------
    % Muestra el título en la ventana de búsqueda.
    
% Rafael Bayareh M.
% ------------------------------------------------------------
function x = global_readPNG
format bank;

myFolder = uigetdir(pwd,'Choose Data folder...');
filePattern = fullfile(myFolder, '*.png');
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