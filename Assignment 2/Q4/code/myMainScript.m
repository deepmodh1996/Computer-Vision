i=0;


if i==0
I1 = (imread('../input/hill/1.JPG'));
I2 = (imread('../input/hill/2.JPG'));
I3 = (imread('../input/hill/3.JPG'));
end


if i==1
I1 = (imread('../input/ledge/1.JPG'));
I2 = (imread('../input/ledge/2.JPG'));
I3 = (imread('../input/ledge/3.JPG'));
end

if i==2
I1 = (imread('../input/pier/1.JPG'));
I2 = (imread('../input/pier/2.JPG'));
I3 = (imread('../input/pier/3.JPG'));
end


if i==3
I1 = (imread('../input/monument/1.JPG'));
I2 = (imread('../input/monument/2.JPG'));
end


threshold = 1;
panaroma  = imstitch(I1,I2,threshold);

if i~=3
panaroma =  imstitch(panaroma,I3,threshold);
end

imshow(panaroma);