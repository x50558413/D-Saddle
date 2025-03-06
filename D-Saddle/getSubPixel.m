function [saddlePoints] = getSubPixel(imagePyramid,points)
%GETSUBPIXEL Summary of this function goes here
%   Detailed explanation goes here

%%
saddlePoints = [];

for i_subPix = 1:length(points(:,1))
    
    levelPix = points(i_subPix,1);
    xPix = points(i_subPix,2);
    yPix = points(i_subPix,3);
       
    %% Calculate weight using response strength for 3x3 area
    
    for i = 1:length(xPix(:,1))
        %%
        mx = imagePyramid{levelPix};
        
        areaResponse = [mx(yPix-1:yPix+1,xPix-1);mx(yPix-1:yPix+1,xPix);mx(yPix-1:yPix+1,xPix+1)];
        weight = sum(abs(median(areaResponse) - areaResponse));
        
        saddlePoints(end+1,:) = [points(i_subPix,1),xPix+weight,yPix+weight]; % Level, x, y
        
    end
    %{
    [ySubPix,xSubPix] = subPixel(imagePyramid{saddleMask(i_subPix,1)},yPix,xPix);
    
    if isempty(ySubPix) ~= 1
        saddlePoints(end+1,:) = [saddleMask(i_subPix,1),xSubPix,ySubPix]; % Level, x, y
    end
    %}
end

end

