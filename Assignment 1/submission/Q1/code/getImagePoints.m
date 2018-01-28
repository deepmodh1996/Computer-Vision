clear;
figure
imshow('image.jpg')
% Call getpts to choose points interactively in the displayed image using the mouse. 
% Double-click to complete your selection. When you are done, getpts returns the coordinates of your points.
zoom on;

[x,y] = ginput;

xoriginal2D = [x'; y']
