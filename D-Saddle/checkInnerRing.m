function [logicP1,logicP2,logicP3,logicP4] = checkInnerRing(groupCenterP1P2,groupLeftRightP1P2,groupTopCrossLR,groupTopCrossRL)
%CHECKINNERRING Summary of this function goes here
%   Check inner ring pattern

% Pattern 1
logicP1 = [];
logicP1(1:length(groupCenterP1P2(1,:))) = 1;

for i_P1 = 1:2
    logicP1no1 = groupCenterP1P2(i_P1,:) > groupLeftRightP1P2(1,:);
    logicP1no2 = groupCenterP1P2(i_P1,:) > groupLeftRightP1P2(2,:);
    logicP1 = logicP1.*logicP1no1.*logicP1no2;
end

% Pattern 2
logicP2 = [];
logicP2(1:length(groupCenterP1P2(1,:))) = 1;

for i_P2 = 1:2
    logicP2no1 = groupCenterP1P2(i_P2,:) < groupLeftRightP1P2(1,:);
    logicP2no2 = groupCenterP1P2(i_P2,:) < groupLeftRightP1P2(2,:);
    logicP2 = logicP2.*logicP2no1.*logicP2no2;
end

% Pattern 3
logicP3 = [];
logicP3(1:length(groupTopCrossLR(1,:))) = 1;

for i_P3 = 1:2
    logicP3no1 = groupTopCrossLR(i_P3,:) > groupTopCrossRL(1,:);
    logicP3no2 = groupTopCrossLR(i_P3,:) > groupTopCrossRL(2,:);
    logicP3 = logicP3.*logicP3no1.*logicP3no2;
end

% Pattern 4
logicP4 = [];
logicP4(1:length(groupTopCrossLR(1,:))) = 1;

for i_P4 = 1:2
    logicP4no1 = groupTopCrossLR(i_P3,:) < groupTopCrossRL(1,:);
    logicP4no2 = groupTopCrossLR(i_P3,:) < groupTopCrossRL(2,:);
    logicP4 = logicP4.*logicP4no1.*logicP4no2;
end

end

