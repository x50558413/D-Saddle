function [pointSaddle,levelSaddle,responSaddle] = D_Saddle(image)
%D_SADDLE_REV Summary of this function goes here
%   Saddle Division
%   Without threshold

warning off;

%% Create pyramid level
% Default settings for Saddle
% Scaling factor is 1.3
% Total level pyramid is 6

[imagePyramid] = createPyramidDSaddle(image);

%% Saddle part
respon = [];
saddleCandidate = [];
% totalPyramid = 6;
totalPyramid = 4;
% Create white image for level 1 pyramid for response

for i_level = 1:totalPyramid %level that contains the potential keypoint
    [row,column] = size(imagePyramid{i_level});
    
    for i_row = 4:row-3
        
        coordinate = [];
        
        elementRow = imagePyramid{i_level}(i_row,4:column-3);
        coordinate(1,:) = [4:column-3];
        coordinate(2,:) = i_row; % [x;y]
        
        %% Inner ring
        leftInner = abs(imagePyramid{i_level}(i_row-2:2:i_row+2,2:column-5));
        centerInner = abs(imagePyramid{i_level}(i_row-2:2:i_row+2,4:column-3));
        rightInner = abs(imagePyramid{i_level}(i_row-2:2:i_row+2,6:column-1));
        
        %% Check inner pattern
        % Extract group element for Pattern 1 & Pattern 2
        groupCenterP1P2 = centerInner(1:2:end,:);
        groupLeftRightP1P2 = [leftInner(2,:);rightInner(2,:)];
        
        % Extract group element for Pattern 3 & Pattern 4
        groupTopCrossLR =  [leftInner(1,:);rightInner(end,:)];
        groupTopCrossRL =  [rightInner(1,:);leftInner(end,:)];
        
        [logicP1,logicP2,logicP3,logicP4] = checkInnerRing(groupCenterP1P2,groupLeftRightP1P2,groupTopCrossLR,groupTopCrossRL);
        
        %% Calculate median value
        % Using 4 pixels
        medianP1P2 = median([groupCenterP1P2;groupLeftRightP1P2]);
        medianP3P4 = median([groupTopCrossLR;groupTopCrossRL]);
        
        % Using 8 pixels
        medianP1234 = median([groupCenterP1P2;groupLeftRightP1P2;groupTopCrossLR;groupTopCrossRL]);
        
        %% Get median intensity from inner pattern
        
        % Use 8 pixels
        logic8pix = (logicP1 | logicP2) & (logicP3 | logicP4);
        
        idxMedian8pix = find(logic8pix == 1);
        valMedian8pix = medianP1234(idxMedian8pix);
        
        % Use 4 pixels
        logic4pixP1P2 = ((logicP1 | logicP2) - logic8pix) > 0;
        logic4pixP3P4 = ((logicP3 | logicP4) - logic8pix) > 0;
        
        idxMedian4pixP1P2 = find(logic4pixP1P2 == 1);
        idxMedian4pixP3P4 = find(logic4pixP3P4 == 1);
        valMedian4pixP1P2 = medianP1234(idxMedian4pixP1P2);
        valMedian4pixP3P4 = medianP1234(idxMedian4pixP3P4);
        
        logicInner = logicP1 | logicP2 | logicP3 | logicP4;
        
        %% Eliminate those without
        
        %% Skip if all innner ring failed test
        
        if (isempty(idxMedian8pix) & isempty(idxMedian4pixP1P2) & isempty(idxMedian4pixP3P4)) ~= 1
            
            %% Outer ring
            outerRing = [];
            % Get array of outer ring
            outerRing(1,:) = imagePyramid{i_level}(i_row+3,4:column-3);
            outerRing(2,:) = imagePyramid{i_level}(i_row+3,5:column-2);
            outerRing(3,:) = imagePyramid{i_level}(i_row+2,6:column-1);
            outerRing(4,:) = imagePyramid{i_level}(i_row+1,7:column);
            outerRing(5,:) = imagePyramid{i_level}(i_row,7:column);
            outerRing(6,:) = imagePyramid{i_level}(i_row-1,7:column);
            outerRing(7,:) = imagePyramid{i_level}(i_row-2,6:column-1);
            outerRing(8,:) = imagePyramid{i_level}(i_row-3,5:column-2);
            outerRing(9,:) = imagePyramid{i_level}(i_row-3,4:column-3);
            outerRing(10,:) = imagePyramid{i_level}(i_row-3,3:column-4);
            outerRing(11,:) = imagePyramid{i_level}(i_row-2,2:column-5);
            outerRing(12,:) = imagePyramid{i_level}(i_row-1,1:column-6);
            outerRing(13,:) = imagePyramid{i_level}(i_row,1:column-6);
            outerRing(14,:) = imagePyramid{i_level}(i_row+1,1:column-6);
            outerRing(15,:) = imagePyramid{i_level}(i_row+2,2:column-5);
            outerRing(16,:) = imagePyramid{i_level}(i_row+3,3:column-4);
            
            outerRing = abs(outerRing);
            
            % Select outer ring based on the inner ring test
            idxPassInnerTest = [idxMedian8pix,idxMedian4pixP1P2,idxMedian4pixP3P4];
            valOuterRing = outerRing(:,idxPassInnerTest);
            medPassInnerTest = [valMedian8pix,valMedian4pixP1P2,valMedian4pixP3P4]; % This is median from innner ring
            cooPassInnerTest = coordinate(:,idxPassInnerTest);
            
            medOuterRing = median(valOuterRing);
            
            [goodIdx] = outerRingTest(valOuterRing,medOuterRing);
            
            if isempty(goodIdx) ~= 1
                
                saddleTemp = [];
                saddleTemp(:,3) = cooPassInnerTest(2,goodIdx)'; % y
                saddleTemp(:,2) = cooPassInnerTest(1,goodIdx)'; % x
                saddleTemp(1:end,1) = [i_level];
                
                % Response strength
                medCandi = medOuterRing(goodIdx);
                valOuterCandi = valOuterRing(:,goodIdx);
                responseCandi = sum(abs(medCandi - valOuterCandi));
                
                % saddleTemp(:,4) = responseCandi;
                
                if i_level == 1
                    
                    %% Non-maxima supression
                    
                    radius = 1;
                    cim = imagePyramid{1};
                    
                    sze = 2*radius+1;                   % Size of dilation mask.
                    % mx = ordfilt2(cim,sze^2,ones(sze)); % Grey-scale dilate.
                    mx = imdilate(cim, strel('disk',radius));
                
                    areaCandi = [];
                    x_mx = [];
                    y_mx = [];
                    maximaIdx = [];
                    
                    y_mx = saddleTemp(:,3);
                    x_mx = saddleTemp(:,2);
                    
                    areaCandi = [mx(y_mx-1:y_mx+1,x_mx-1);mx(y_mx-1:y_mx+1,x_mx);mx(y_mx-1:y_mx+1,x_mx+1)];
                    
                    % Maxima should be on row 5
                    
                    [~,idxMax] = max(areaCandi);
                    maximaIdx = find(idxMax == 5 & responseCandi > 0);
                    
                    if isempty(maximaIdx) ~= 1
                        
                        saddleMaxima = saddleTemp(maximaIdx,:);
                        respon = [respon,responseCandi(maximaIdx)];
                        saddleCandidate = [saddleCandidate;saddleMaxima]; % Level, x, y
                        
                    end
                    
                else
                    
                    maxRespon = find(responseCandi > 0);
                    
                    if isempty(maxRespon) ~= 1
                        saddleCandidate = [saddleCandidate;saddleTemp(maxRespon,:)]; % Level, x, y
                        respon = [respon,responseCandi(maxRespon)];
                    end

                end
                
            end
        end
    end
end


%% Sub-pixel

[saddleSubPix] = getSubPixel(imagePyramid,saddleCandidate);
levelSaddle = saddleCandidate(:,1);
responSaddle = respon';

%% Change point according to first level dimension (Original dimension)

% to get the original size back
% size image1/image1.2 = 3.6954
% t = imresize(imagePyramid{6},3.6954);

% Calculate size dimension for each level

for i_size = 1:length(imagePyramid)
    
    [dimR,~] = size(imagePyramid{i_size});
    
    dimArry(i_size) = dimR;
    
end

factorSize = dimArry(1)./dimArry(saddleSubPix(:,1));

pointSaddle(:,1) = saddleSubPix(:,2).*factorSize'; % x
pointSaddle(:,2) = saddleSubPix(:,3).*factorSize'; % y

end