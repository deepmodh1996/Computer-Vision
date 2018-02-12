function [ H ] = ransacHomography( x1, x2, thresh)
n    = size(x1, 1);
bestDis   =thresh * n;
bestH = eye([3,3]);
numTrials = 3000;
inliercount = 0;

for ii=1:numTrials
    indices = randperm(n, 4);
    ii = ii+1;
    % normalize the points
    [samples1, norm1] = vision.internal.normalizePoints(x1(indices, :)', 2, 'double');
    [samples2, norm2] = vision.internal.normalizePoints(x2(indices, :)', 2, 'double');
    % get the homography from the samples collected
    H = homography(samples1',samples2');
    % denormalising H
    H = H / H(end);
    H = norm1' * (H / norm2');
    % evaluate the obtained H to find the distances array
    
    
    % distances = zeros(n);
    % for i = 1:n
    % D = H*[x1(i, 1) ; x1(i, 2) ; 1];
    % dist = norm([x2(i, 1), x2(i, 2)] - [D(1, 1)/D(3,1), D(2,1)/D(3,1)]);
    % dist is distance in pixel between mapped point(H*x2(i)) and x1(i)
    % distances(i) = dist;
    % end

    temp1 = bsxfun(@plus, x1 * H(1:2, 3), H(3,3));
    finiteindices = abs(temp1) > eps(class(x1));
    temp = x1 * H(1:2, 1:2);
    temp = bsxfun(@plus, temp, H(3,1:2));
    % At finiteindices we get the points by dividing with third coordinate from homogenous
    % At infinite we make the value threshold --> ing=finite
    temp(~finiteindices,:) = x2(~finiteindices,:)+thresh;
    temp(finiteindices,:)  = bsxfun(@rdivide, temp(finiteindices,:), temp1(finiteindices));
    % Now subtract obtained values from original values and find out dist
    diffp = temp - x2;
    distances = sqrt(abs(diffp(:,1)).^2 + abs(diffp(:,2)).^2);
    % make the values of distances > thres to be thres
    distances(distances > thresh) = thresh;
    % find the sum of distances
    tempdis = sum(distances);
    % If the calculated sum is less than bestDis till now update bestDis
    if tempdis < bestDis
        bestDis = tempdis;
        bestH = H;
        inliercount = sum(distances < thresh);
    end
end

finalConsensusSize = inliercount
H = bestH;