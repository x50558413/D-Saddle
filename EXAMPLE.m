
clear all;  clc; %close all;
warning off;
addpath(genpath('D-Saddle'));
%% NOTES:
% 1) pointSaddle
     % D-Saddle points detected on image
     % Column 1: coordinate at x-axis, Column 2: coordinate at y-axis.
     % The coordinate is according to the size of the input image
     
% 2) octaveSaddle
    % Respective image in the pyramid (octave) that pointSaddle been
    % detected on

% 3) responSaddle
    % Structure response for each pointSaddle. Can be used to select points
    % with the strongest response

% Further details of D-Saddle feature can be found at:
% Roziana Ramli, Mohd Yamani Idna Idris, Khairunnisa Hasikin, et al.,
% “Feature-Based Retinal Image Registration Using D-Saddle Feature,”
% Journal of Healthcare Engineering, vol. 2017, Article ID 1489524, 15
% pages, 2017. doi:10.1155/2017/1489524

%% Read image

imageOriginal = imread('TEST_image.jpg');
% The input image must be grayscale
image = rgb2gray(imresize(imageOriginal,0.2));

%% Perfom detection

[pointSaddle,octaveSaddle,responSaddle] = D_Saddle(image);

%% Plot the points detected

figure, imshow(image); hold on;
plot(pointSaddle(:,1),pointSaddle(:,2),'r+','MarkerSize',3);

