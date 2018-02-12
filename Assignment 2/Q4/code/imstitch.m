function [ panaroma ] = imstitch( im1 , im2 ,threshold)


% Get the matchedPoints using detectSURFFeatures and extractFeatures std matlab fns
I1 = rgb2gray(im1);
I2 = rgb2gray(im2);
points1 = detectSURFFeatures(I1);
points2 = detectSURFFeatures(I2);

n = min(length(points1), length(points2));

we1 = points1.selectStrongest(n);
we2 = points2.selectStrongest(n);

[f1,vpts1] = extractFeatures(I1,points1);
[f2,vpts2] = extractFeatures(I2,points2);

indexPairs = matchFeatures(f1,f2) ;

matchedPoints1 = vpts1(indexPairs(:,1));
matchedPoints2 = vpts2(indexPairs(:,2));

x1 = matchedPoints2(:).Location;
x2 = matchedPoints1(:).Location;

figure; showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
legend('matched points 1','matched points 2');

tform = ransacHomography(x1, x2,threshold); % definetly sure that this is the best H possible from I2 to I1. I1 = H*I2
tform = projective2d(tform);
panaroma = createPanaroma(im1,im2,tform);

end