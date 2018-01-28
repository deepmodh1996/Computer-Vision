%% MyMainScript
clear;
tic;
%% Your code here
% Collected Data

% World Coordinates (X,Y,Z)
XX =  [2 3.01 1 -0.01 -0.01 0.01 0 2];
YY =  [0 0 0 2 3 2 3 0];
ZZ = [5 3 7 2 5 6 8 1];


Xoriginal3D = [XX ; YY ; ZZ];

% Image Coordinates (x,y)


% The Image coordinates are obtained using ginput function as below
% clear;
% figure
% imshow('image.jpg')
% [x,y] = ginput;

% xoriginal2D = [x'; y']


xoriginal2D =1.0e+03 *[2.001    2.3130    1.7309    1.0352    0.7654    1.0421    0.7753    2.0219
                       2.0982    1.4235    2.6934    1.1214    2.1316    2.4390    3.1496    0.7849];


NumPts = size(Xoriginal3D,2);


% Homogenising the coordinates
homolastrow = ones(1,NumPts);

X = Xoriginal3D;
X = [X ; homolastrow]

x = xoriginal2D;
x = [x; homolastrow]

% Normalising  The Data and finding out T

fin = find(abs(x(3,:)) > eps);
c = mean( x(1:2, fin)')';            % Centroid of finite points
newp(1, fin) =  x(1, fin)-c(1); % Shift origin to centroid.
newp(2, fin) =  x(2, fin)-c(2);

dist = sqrt(newp(1, fin).^2 + newp(2, fin).^2);
mdis = mean(dist(:));  % Ensure dist is a column vector for Octave 3.0.1

sc = sqrt(2)/mdis;

T = [sc   0   -sc*c(1)
     0     sc -sc*c(2)
     0       0      1      ]

xprime = T* x;


% Normalising The Data and finding out U
fin = find(abs(X(4,:)) > eps);
c = mean( X(1:3, fin)')';            % Centroid of finite points
newp(1, fin) =  X(1, fin)-c(1); % Shift origin to centroid.
newp(2, fin) =  X(2, fin)-c(2);
newp(3, fin) =  X(3, fin)-c(3);

dist = sqrt(newp(1, fin).^2 + newp(2, fin).^2 + newp(3, fin).^2);
mdis = mean(dist(:));  % Ensure dist is a column vector for Octave 3.0.1

sc = sqrt(3)/mdis;

U = [sc   0   0 -sc*c(1)
     0     sc 0 -sc*c(2)
     0       0  sc -sc*c(3)
     0       0      0    1]

Xprime = U * X;

% Getting the Normalised Projection Matrix a as given in the slides

XW = Xprime(1,1:NumPts);
YW = Xprime(2,1:NumPts);
ZW = Xprime(3,1:NumPts);

xi = xprime(1,1:NumPts);
yi = xprime(2,1:NumPts);

a = [];
for i=1:NumPts
    axi = [-XW(i) -YW(i) -ZW(i) -1 0 0 0 0 xi(i)*XW(i) xi(i)*YW(i) xi(i)*ZW(i) xi(i)];
    ayi = [0 0 0 0 -XW(i) -YW(i) -ZW(i) -1 yi(i)*XW(i) yi(i)*YW(i) yi(i)*ZW(i) yi(i)];
    a = [a ; axi ; ayi];
end

% finding the u,v,d by svd
[u,d,v] = svd(a);
%v(:,12);
h = reshape(v(:,12),4,3)';

% Desnormalization of Pcap to P
P = inv(T) * h * U;
h1 = P(:,1:3);
h2 = P(:,4);


X0 = -inv(h1) * h2


% QR decomposition to get k and r
c = -h1(3,3)/sqrt(h1(3,2)^2 + h1(3,3)^2);
s = h1(3,2)/sqrt(h1(3,2)^2 + h1(3,3)^2);
qx = [1 0 0; 0 c -s; 0 s c];

k = h1 * qx;

c = h1(3,3)/sqrt(h1(3,1)^2 + h1(3,3)^2);
s = h1(3,1)/sqrt(h1(3,1)^2 + h1(3,3)^2);
qy = [c 0 s; 0 1 0; -s 0 c];

k = k * qy;

c = -h1(2,2)/sqrt(h1(2,2)^2 + h1(2,1)^2);
s = h1(2,1)/sqrt(h1(2,2)^2 + h1(2,1)^2);
qz = [c -s 0; s c 0; 0 0 1];

k = k * qz;

r = qz' * qy' * qx';

if r(1,1) < 0
    d = diag([-1 -1 ones(1,1)]);
    r = r * d;
    k = d * k;
end
K = k
R = r

% Calculating RMSE
L = [1 0 0 -X0(1)
     0 1 0 -X0(2)
     0 0 1 -X0(3)];

XWhole = [];
for i=1:NumPts
    XWhole = [XWhole ; X(:,i)'];
end
XWhole = XWhole';
xtemp  = K*R*L * XWhole;
xObtained = ones(2,NumPts);
for i=1:NumPts
    xObtained(1,i) = xtemp(1,i) / xtemp(3,i);
    xObtained(2,i) = xtemp(2,i) / xtemp(3,i);
end

xtemp = xObtained - xoriginal2D;
ErrorMatrix = xtemp * xtemp';
RMSE = sqrt(ErrorMatrix(1,1) + ErrorMatrix(2,2) / NumPts )/37.795275590551



% xObtained vs xoriginal2D on the image

xObtainedx =  xObtained(1,:);
xObtainedy =  xObtained(2,:);

xoriginal2Dx = xoriginal2D(1,:);
xoriginal2Dy = xoriginal2D(2,:);


image = imread('image.jpg');
imshow(image);
hold on;
plot(xObtainedx, xObtainedy, 'r*', 'LineWidth', 2, 'MarkerSize', 5);
plot(xoriginal2Dx, xoriginal2Dy, 'b*', 'LineWidth', 2, 'MarkerSize', 5);
title('BLUE - ORIGINAL CONTROL POINTS;RED - OBTAINED', 'FontSize', 12);
