function [ panorama ] = createPanaroma( im1,im2,tform)
%CREATEPANAROMA Summary of this function goes here
%   Detailed explanation goes here
I = rgb2gray(im1);

imsize = size(I);
% getlimits of the tform and Imagesize
[xlimit(1,:), ylimit(1,:)] = outputLimits(tform, [1 imsize(2)], [1 imsize(1)]);
% finding the minimum and maximum output limits
minx = min([1; xlimit(:)]);
miny = min([1; ylimit(:)]);
maxx = max([imsize(2); xlimit(:)]);
maxy = max([imsize(1); ylimit(:)]);
% get width and height of panorama
width  = round(maxx - minx);
height = round(maxy - miny);
% Initialize the "empty" panorama and specify the dimensions of panaroma view.
panorama = zeros([height width 3], 'like', I);
panoramaView = imref2d([height width], [minx maxx], [miny maxy]);
% Warp the images and get panaroma by using the max value of both the images at the overlap
warpedImage = imwarp(im1, projective2d(eye(3)), 'OutputView', panoramaView);
panorama(:,:,:) = max(panorama(:,:,:),warpedImage(:,:,:));
warpedImage = imwarp(im2, tform, 'OutputView', panoramaView);
panorama(:,:,:) = max(panorama(:,:,:),warpedImage(:,:,:));

end

