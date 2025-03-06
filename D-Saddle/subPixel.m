function [subr,subc] = subPixel(cim,r,c)
%SUBPIXEL Summary of this function goes here
%   Detailed explanation goes here

[rows,cols] = size(cim);

ind = sub2ind(size(cim),r,c);   % 1D indices of feature points
w = 2;         % Width that we look out on each side of the feature
% point to fit a local parabola

% Indices of points above, below, left and right of feature point
indrminus1 = max(ind-w,1);
indrplus1  = min(ind+w,rows*cols);
indcminus1 = max(ind-w*rows,1);
indcplus1  = min(ind+w*rows,rows*cols);

% Solve for quadratic down rows
rowshift = zeros(size(ind));
cy = cim(ind);
ay = (cim(indrminus1) + cim(indrplus1))/2 - cy;
by = ay + cy - cim(indrminus1);
rowshift(ay ~= 0) = -w*by(ay ~= 0)./(2*ay(ay ~= 0));       % Maxima of quadradic
rowshift(ay == 0) = 0;

% Solve for quadratic across columns
colshift = zeros(size(ind));
cx = cim(ind);
ax = (cim(indcminus1) + cim(indcplus1))/2 - cx;
bx = ax + cx - cim(indcminus1);
colshift(ax ~= 0) = -w*bx(ax ~= 0)./(2*ax(ax ~= 0));       % Maxima of quadradic
colshift(ax == 0) = 0;

subr = r+rowshift;  % Add subpixel corrections to original row
subc = c+colshift;  % and column coords.

end

