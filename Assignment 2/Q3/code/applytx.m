function [ im2 ] = applytx( im1 , H , W , tx)
%APPLYTX Summary of this function goes here
%   Detailed explanation goes here

im2 = zeros(H,W);
if tx > 0,
    im2(:,tx+1:W) = im1(:,1:W-tx);
elseif tx < 0,
    im2(:,1:W+tx) = im1(:,-tx+1:W);
else
    im2 = im1;            
end

end