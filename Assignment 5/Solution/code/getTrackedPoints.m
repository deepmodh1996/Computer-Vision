function [ trackedPoints , noOfFeatures ] = getTrackedPoints(patchsize)
%GETTRACKEDPOINTS Summary of this function goes here
%   Detailed explanation goes here

myFolder = '../input';
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The input folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end
filePattern = fullfile(myFolder, '*.jpg');
jpegFiles = dir(filePattern);
firstframe = imread('../input/1.jpg');
I = double(firstframe);

% C = corner(I,'Harris');
% noOfgoodcorners = length(C)
% colormap('gray');
% imagesc(firstframe);
% hold on;
% plot(C(:,1),C(:,2),'r*');
% hold off;
% saveas(figure,'../output/0FIRSTFRAME_MAINgoodcorners.jpg');

% variable trackedPoints assumes that you have an array of size 
% No of frames * 2(x, y) * No Of Features
% noOfFeatures is the number of features you are tracking
% Frames is array of all the frames(assumes grayscale)


% (d) For every feature point you will take a template patch centered around that point.
% Patch size should be a parameter but, ideally, you should start around 40 pixels.

windowSize = patchsize/2;


% Use the minor eigen-value method to detect salient feature points in frame 1.

[ r, c] = getHarrisCorners( double(firstframe) );

[rows cols temp] = size(firstframe);

[goodcorners , goodr, goodc] = getGoodCorners(r , c , windowSize , rows , cols,firstframe);

noOfFeatures = length(goodcorners)
% (b) Display major features points overlay-ed on the first frame, for feature point detection
% you can use Harris corner detector or SURF; both are inbuilt in MATLAB.

h = figure;
set(h, 'Visible', 'off');
colormap('gray');
imagesc(firstframe);
hold on;
plot(goodc,goodr,'*');
hold off;
saveas(h,'../output/0FIRSTFRAME_MAINCORNERS.jpg');





trackedPoints(1:length(jpegFiles),1:2,1:length(goodcorners)) = 0;


globalTemplate = double(firstframe);



for i = 1:length(goodcorners)


	cornercheck1 = goodcorners{i}(1)-windowSize;
	cornercheck2 = goodcorners{i}(1)+windowSize;
	cornercheck3 = goodcorners{i}(2)-windowSize;
	cornercheck4 = goodcorners{i}(2)+windowSize;

	% Initialize p
	p = [0 0 0 0 goodcorners{i}(1) goodcorners{i}(2)];
	% Get the Template and all required vals
	Template = firstframe(cornercheck1:cornercheck2,cornercheck3:cornercheck4);
	Template= double(Template);
	globalTemplate(cornercheck1:cornercheck2,cornercheck3:cornercheck4) = 255;
	[x,y]=ndgrid(0:size(Template,1)-1,0:size(Template,2)-1);
	TemplateCenter=size(Template)/2;
	x=x-TemplateCenter(1);
	y=y-TemplateCenter(2);
	% Now for each Frame
	framenum = 1;
	for k = 1:length(jpegFiles)
		if(k==60)
		continue;
		end;
		baseFileName = strcat(num2str(k),'.jpg');
		fullFileName = fullfile(myFolder, baseFileName);
		fprintf(1, 'Now reading %s - %s\n', fullFileName,num2str(i));
		NextFrame = imread(fullFileName);
		I_nextFrame= double(NextFrame);
		p = applyKLTalgo( Template , x, y , p , I_nextFrame );
		trackedPoints(k,1,i) = p(6);
		trackedPoints(k,2,i) = p(5);
		framenum = framenum + 1;
		% after every 10 to 20 frames you should
		% extract a new template, since the patch may have changed a lot
		if framenum == 16
			cornercheck1 = floor(p(5)-windowSize);
			cornercheck2 = floor(p(5)+windowSize);
			cornercheck3 = floor(p(6)-windowSize);
			cornercheck4 = floor(p(6)+windowSize);
			if (cornercheck1 > 0 && cornercheck2 <= rows && cornercheck3 > 0 && cornercheck4< cols)
				Template = I_nextFrame(cornercheck1:cornercheck2,cornercheck3:cornercheck4);
				p = [0 0 0 0 p(5) p(6)];
				Template= double(Template);
				globalTemplate(cornercheck1:cornercheck2,cornercheck3:cornercheck4) = 255;
				[x,y]=ndgrid(0:size(Template,1)-1,0:size(Template,2)-1);
				TemplateCenter=size(Template)/2;
				x=x-TemplateCenter(1); y=y-TemplateCenter(2);
			end
			framenum = 1;
		end
	end
end




h = figure;
set(h, 'Visible', 'on');
colormap('gray');
imagesc(globalTemplate);
saveas(h,'../output/0globalTemplate.jpg');




noOfFeatures = length(goodcorners);
end