function [goodIdx] = outerRingTest(valOuterRing,medPassInnerTest)
%OUTERRINGTESTREVICE Summary of this function goes here
%   Detailed explanation goes here
parameterOffset = 0.0010;
goodIdx = [];

redPattern = valOuterRing < (medPassInnerTest - parameterOffset);
bluePattern = (medPassInnerTest - parameterOffset <= valOuterRing) & (valOuterRing <= medPassInnerTest + parameterOffset);
greenPattern = valOuterRing > medPassInnerTest + parameterOffset;

redNumber = double(redPattern);
blueNumber = double(bluePattern);
greenNumber = double(greenPattern);

% Assign each color a uniq number
redNumber(find(redPattern == 1)) = 2;
greenNumber(find(greenPattern == 1)) = 3;

arrayAllPattern = redNumber + blueNumber + greenNumber;

listSeqPattern = [];
listSeq2ndPattern = [];
blueRepeatPattern = [];

% Each sequence has 4 columns where:
% - 1st col.:  the value being repeated
% - 2nd col.:  the position of the first value of the sequence
% - 3rd col.:  the position of the last value of the sequence
% - 4th col.:  the length of the sequence

% Find sequence pattern
listSeqPattern = findseq(arrayAllPattern',2);
[rowI,colJ] = ind2sub(size(arrayAllPattern'),listSeqPattern(:,2));
extraSeqPattern = listSeqPattern;
extraSeqPattern(:,5) = rowI;
extraSeqPattern(:,6) = colJ;

% Find pattern with blue dot
blueRepeatPattern = extraSeqPattern(find(extraSeqPattern(:,1) == 1),:);
% Find pattern without blue dot
listSeqGoodPattern = extraSeqPattern(find(extraSeqPattern(:,1) ~= 1),:);

% Bad point
% Length of repeated pattern (red & green dots) less than 4
rowOtherPatRepeat = findseq(listSeqGoodPattern(:,5));
if isempty(rowOtherPatRepeat) ~= 1
    badRowRedGreen = rowOtherPatRepeat(rowOtherPatRepeat(:,4) < 4);
else
    badRowRedGreen = 0;
end
% Length of repeated pattern (blue dot) larger than 2
rowBluePatRepeat = findseq(blueRepeatPattern(:,5)); % Row is refer to the row of arrayAllPattern not image
if isempty(rowBluePatRepeat) ~= 1
    badRowBlue = rowBluePatRepeat(rowBluePatRepeat(:,4) > 2);
else
    badRowBlue = 0;
end

%% Good point
% First, Remove all bad points
idxBadBlue = find(ismember(listSeqGoodPattern(:,5), badRowBlue));
idxBadRedGreen = find(ismember(listSeqGoodPattern(:,5), badRowRedGreen));

% Combine bad index
idxBadBlueUniq = idxBadBlue(find(~ismember(idxBadBlue,idxBadRedGreen)));
idxBad = [idxBadRedGreen;idxBadBlueUniq];

filterOutBadPoint = listSeqGoodPattern;
filterOutBadPoint(idxBad,:) = [];

if isempty(filterOutBadPoint) ~= 1
    % If there is uniq elements in filterOutBadPoint...we want this remove
    seqFilterRow = findseq(filterOutBadPoint(:,5));
    if isempty(seqFilterRow) ~= 1
        idxBadUnique = find(~ismember(filterOutBadPoint(:,5),seqFilterRow(:,1)));
        % Remove unique elements
        filterOutBadPoint(idxBadUnique,:) = [];
    end
    
    % Filter out filterOutBadPoint with repeat pattern
    seqFilterRow = [];
    startSeqFil = [];
    endSeqFil = [];
    
    countGoodIdx = 0;
    goodIdxPattern = 0;
    
    seqFilterRow = findseq(filterOutBadPoint(:,5));
    if isempty(seqFilterRow) ~= 1
        startSeqFil = seqFilterRow(:,2);
        endSeqFil = seqFilterRow(:,3);
        
        for i_pat2ndRepeat = 1:length(seqFilterRow(:,1))
            elementRow = [];
            elementRow = filterOutBadPoint(startSeqFil(i_pat2ndRepeat):endSeqFil(i_pat2ndRepeat),:);
            infoSeq = findseq(elementRow(:,1));
            
            if isempty(infoSeq) == 1
                % Good
                countGoodIdx = countGoodIdx + 1;
                goodIdx(countGoodIdx) = elementRow(1,5);
            end
            
        end
    else
        goodIdx = [];
    end
else
    goodIdx = [];
end

end

