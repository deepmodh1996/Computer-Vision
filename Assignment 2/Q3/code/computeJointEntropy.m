function [ JointEntropy ] = computeJointEntropy( im1,im2 )
%COMPUTEJOINTENTROPY Summary of this function goes here
%   Detailed explanation goes here

% Ref :https://www.codementor.io/tips/4397721308/mutual-information-and-joint-entropy-of-two-images-matlab

% binsize assumed to be 10

numbins = ceil(255/10);
P = zeros(numbins);
temp = im1;
im1 = im1(im2 ~=0 & im1 ~=0);
im2 = im2(im2 ~=0 & temp ~=0);
im1 = ceil(im1/20);
im2 = ceil(im2/20);

for i=1:length(im1)
    P(im1(i),im2(i)) = P(im1(i),im2(i))+1;
end
P = P/sum(P(:));

JointEntropy = -sum(P(P > 0).*log(P(P > 0)));
end

