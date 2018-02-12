i=1;

if i==0
    im1 = double(rgb2gray(imread('../input/flash1.jpg'))); im1 = im1+1;
    im2 = double(rgb2gray(imread('../input/noflash1.jpg'))); im2 = im2+1;
else
    im1 = double((imread('../input/barbara.png'))); im1 = im1+1;
    im2 = double((imread('../input/negative_barbara.png'))); im2 = im2+1;
end

[height,width] = size(im2);

% rotate the moving image counter-clockwise by 23.5 degrees
im2 = imrotate(im2,23.5,'bilinear','crop');

% translate it by -3 pixels in the X direction
im2 = applytx(im2,height,width,-257);
% and add uniform random noise in the range [0,8] (on a 0-255 scale)
im2 = im2 + rand(size(im2))*8;
% Set negative-valued pixels to 0 and pixels with value more than 255 to 255
im2(im2 < 0) = 0; im2(im2 > 255)= 255;
JointHistogramMatrix = zeros(51,521);

minimum = 0;
minimumtx = 0;
minimumth = 0;
for ith=-25:1:25
    ith
     temprotated = imrotate(im2,ith,'bilinear','crop');
     temprotated(temprotated < 0) = 0; temprotated(temprotated > 255)= 255;
     for tx=-260:1:260
        temptranslated = applytx(temprotated,height,width,tx);
        temptranslated(temptranslated < 0) = 0; temptranslated(temptranslated > 255)= 255;
        
        JointHistogramMatrix(ith+26,tx+261) = computeJointEntropy(im1,temptranslated);
        

        if ith==-25 && tx==-260
            minimum = JointHistogramMatrix(ith+26,tx+261);
            minimumtx = tx;
            minimumth = ith;
        end

        if JointHistogramMatrix(ith+26,tx+261) < minimum
            minimum = JointHistogramMatrix(ith+61,tx+261);
            minimumtx = tx;
            minimumth = ith;
        end
     end
 end

minimum
minimumth
minimumtx

figure, surf(JointHistogramMatrix);
