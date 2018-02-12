%% Rigit Transform between 2 sets of 3D Points

%% Load Data
%% Your code here
a1=[245, 517];
b1=[282, 494];
c1=[518, 351];
d1=[529, 344];

a2=[870, 505];
b2=[789, 490];
c2=[115, 382];
d2=[80, 377];

ac = mydist(a1, c1);
ad = mydist(a1, d1);
bc = mydist(b1, c1);
bd = mydist(b1, d1);

cr1 = (ac/ad)*(bd/bc);

ac = mydist(a2, c2);
ad = mydist(a2, d2);
bc = mydist(b2, c2);
bd = mydist(b2, d2);

cr2 = (ac/ad)*(bd/bc);

w = zeros(2,1);
a = 1;
b = 36-72*cr1;
c = 324;
d = sqrt(b^2 - 4*a*c);
w(1) = (-b + d) / (2*a);
w(2) = (-b - d) / (2*a);
disp(w);

l = zeros(2,1);
a = 1;
b = 88 - 176*cr2;
c = 1936;
d = sqrt(b^2 - 4*a*c);
l(1) = (-b + d) / (2*a);
l(2) = (-b - d) / (2*a);
disp(l);