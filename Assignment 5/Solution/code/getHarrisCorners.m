function [ r, c] = getHarrisCorners( I )
threshold = 0.25;
sigma=2;
k = 0.04;
dx = [-1 0 1; -1 0 1; -1 0 1]/6;%derivative mask
dy = dx';
Ix = conv2(I, dx, 'same');
Iy = conv2(I, dy, 'same');
g = fspecial('gaussian',fix(6*sigma), sigma); %Gaussien Filter
Ix2 = conv2(Ix.^2, g, 'same');  
Iy2 = conv2(Iy.^2, g, 'same');
Ixy = conv2(Ix.*Iy, g,'same');
R= (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2;
%normalize R so threshold can be a value between 0 and 1 
minr = min(min(R));
maxr = max(max(R));
R = (R - minr) / (maxr - minr);
%compute the local maxima of R above a threshold 5-by-5 windows
maxima = ordfilt2(R, 25, ones(5));
mask = (R == maxima) & (R > threshold);
maxima = mask.*R;
[r,c] = find(maxima>0);
end