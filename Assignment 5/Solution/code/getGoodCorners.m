function [ goodcorners , goodr , goodc ] = getTrackedPoints(r , c , windowSize , rows , cols , firstframe , mineigenthreshold)

% (c) Select those feature points with good structure tensors (recall the class). There can
% be multiple points qualifying the criterion so there should be a parameter to choose
% how many feature points are to be tracked.

[l ~ ]=size(c);
corners = cell(1,l);
goodcorners = cell(1,l);
goodcornerl = 0;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Algo to check the minimum of smaller eignen value of structure tensor is
% greater than threshold
threshold = mineigenthreshold;
% maskDx = [-1 0 1; -1 0 1; -1 0 1];
% maskDy = maskDx';

firstframe = double(firstframe);

for i=1:l
    Ix = ( (firstframe(r(i)+1, c(i)-1)-firstframe(r(i)-1, c(i)-1))/2 + (firstframe(r(i)+1, c(i))-firstframe(r(i)-1, c(i)))/2 + (firstframe(r(i)+1, c(i)+1)-firstframe(r(i)-1, c(i)+1))/2 )/3;
    Iy = ( (firstframe(r(i)-1, c(i)+1)-firstframe(r(i)-1, c(i)-1))/2 + (firstframe(r(i), c(i)+1)-firstframe(r(i), c(i)-1))/2 + (firstframe(r(i)+1, c(i)+1)-firstframe(r(i)+1, c(i)-1))/2)/3;
    H = [Ix^2, Ix*Iy; Ix*Iy, Iy^2]; % structure tensor
    if(Ix==0 && Iy==0)
        continue;
    end;
    e = eig(H);
    emin = min([e(1) e(2)]); % smaller eigen value
    if(emin>threshold) % criterion for good feature
        disp(i);
        disp(emin);
    end;
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Since The Above Method is Not giving the required Corners 
% we are manually selecting the 2 corners on the cup as shown below;
% First we are discarding those corners on which a full patch cannot be applied
% Second we are selecting first two corners that are on the cup
% We can see the globalTemplate image which contains all the templates that are used.
% This includes all updated Templates after every 15 frames also.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




for i=1:l
	cornercheck1 = r(i)-windowSize;
	cornercheck2 = r(i)+windowSize;
	cornercheck3 = c(i)-windowSize;
	cornercheck4 = c(i)+windowSize;
	if (cornercheck1 > 0 && cornercheck2 <= rows && cornercheck3 > 0 && cornercheck4< cols)
		goodcornerl = goodcornerl + 1;
		goodcorners{goodcornerl} = [r(i) c(i)];
	end
end
goodcorners = goodcorners(1:goodcornerl);




% Getting those corners which are moving and to be tracked
goodcorners = goodcorners(1:2);


goodcornerl = length(goodcorners);

goodr = zeros(goodcornerl);
goodc = zeros(goodcornerl);

for j = 1:length(goodcorners)
	goodr(j) = goodcorners{j}(1);
	goodc(j) = goodcorners{j}(2);
end

end