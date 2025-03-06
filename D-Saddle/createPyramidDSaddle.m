function [imagePyramid] = createPyramidDSaddle(image)
%CREATEPYRAMIDDOG Summary of this function goes here
%   Default settings for Saddle
%   Scaling factor is 1.3
%   Total level pyramid is 6

% Initialize settings
% totalPyramid = 6;
totalPyramid = 4;
% scaleFactor = 1/1.3;
scaleFactor = 0.5;
sigma1 = 1;
sigma2 = 1.6; % Use like SIFT

imagePyramid = [];

imgOri = single(im2double(image)); % Normalized the image

imgGauss1 = imgaussfilt(imgOri,sigma1);
imgGauss2 = imgaussfilt(imgOri,sigma2); %Convolve Gaussian with image 

imagePyramid{1} = imgOri - imgGauss2;

imagePyramid{1}(isnan(imagePyramid{1})) = 0 ;

%%
for i_pyramid = 2:totalPyramid
    
    imgGauss1 = [];
    imgGauss2 = [];
    
    imgResize = imresize(imgOri,scaleFactor);
    
    imgGauss1 = imgaussfilt(imgResize,sigma1);
    imgGauss2 = imgaussfilt(imgResize,sigma2); %Convolve Gaussian with image 
    
    imagePyramid{i_pyramid} = imgResize - imgGauss2;
    
    imagePyramid{i_pyramid}(isnan(imagePyramid{i_pyramid})) = 0 ;
    
    imgOri = [];
    imgOri = imgResize;
    
end
end

