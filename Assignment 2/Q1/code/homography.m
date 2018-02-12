function [ H ] = homography( p1, p2 )
%HOMOGRAPHY Summary of this function goes here
%   Detailed explanation goes here
% p1, p2 array of (x, y) points
% H tranforms p2 to p1
n = length(p1);

M = [];
for i = 1:n
    ax = [-p2(i, 1), -p2(i, 2), -1, 0, 0, 0, p1(i,1)*p2(i,1), p1(i,1)*p2(i,2), p1(i,1)];
    ay = [0, 0, 0, -p2(i, 1), -p2(i, 2), -1, p1(i,2)*p2(i,1), p1(i,2)*p2(i,2), p1(i,2)];
    M = [M; ax; ay];
end

[U, D, V] = svd(M);
hv = V(:,end); % hVector
H = [hv(1), hv(2), hv(3); hv(4), hv(5), hv(6); hv(7), hv(8), hv(9)];


end

