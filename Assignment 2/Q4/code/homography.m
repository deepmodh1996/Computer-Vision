function [ H ] = homography( p1, p2 )
% p1, p2 array of (x, y) points
% H tranforms p2 to p1
% n = length(p1);
% This is a standard matrix . from slides
p1x = p1(:, 1);
p1y = p1(:, 2);
p2x = p2(:, 1);
p2y = p2(:, 2);
M = zeros(8, 9);
M(1:2:8, :) = [zeros(4,3), -p1,-ones(4,1), p1x.*p2y, p1y.*p2y, p2y];
M(2:2:8, :) = [p1, ones(4,1), zeros(4,3), -p1x.*p2x, -p1y.*p2x, -p2x];
[S, D , V] = svd(M, 0);
hv = V(:, end);
H = reshape(hv, [3,3]) / hv(9);

end