clear;
close all;
clc;

% for k = 1:length(jpegFiles)
%   baseFileName = strcat(num2str(k),'.jpg');
%   fullFileName = fullfile(myFolder, baseFileName);
%   fprintf(1, 'Now reading %s\n', fullFileName);
%   imageArray = imread(fullFileName);
%   imshow(imageArray);  % Display image.
%   drawnow; % Force display to update immediately.
% end

%% Save all the trajectories frame by frame
% variable trackedPoints assumes that you have an array of size 
% No of frames * 2(x, y) * No Of Features
% noOfFeatures is the number of features you are tracking
% Frames is array of all the frames(assumes grayscale)



% (a) Read the frames from input folder.

myFolder = '../input';
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The input folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end
filePattern = fullfile(myFolder, '*.jpg');
jpegFiles = dir(filePattern);









patchsize = 40;








[trackedPoints , noOfFeatures ] = getTrackedPoints(patchsize);

% noOfFeatures = 2;

noOfPoints = 1;
for k = 1:length(jpegFiles)
	if(k==60)
		continue;
	end;
	baseFileName = strcat(num2str(k),'.jpg');
	fullFileName = fullfile(myFolder, baseFileName);
	fprintf(1, 'Now reading %s\n', fullFileName);
	NextFrame = imread(fullFileName);
	h = figure;
	set(h, 'Visible', 'off');
	colormap('gray');
	imagesc(NextFrame);
	hold on;
	for nF = 1:noOfFeatures
		plot(trackedPoints(1:noOfPoints, 1, nF), trackedPoints(1:noOfPoints, 2, nF),'*')
    end
    hold off;
    saveas(h,strcat('../output/',num2str(k),'.jpg'));
    close all;
    noOfPoints = noOfPoints + 1;
end