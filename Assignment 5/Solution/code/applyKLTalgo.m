function [ finalp ] = applyKLTalgo( Template , x, y , p , nextFrame ,deltapthreshold , maxloopnum)
%APPLYKLTALGO Summary of this function goes here
%   Detailed explanation goes here








% (e) Your motion model for creating the Jacobian matrix should be affine, this motion
% model will also result in six parameters to be tuned.
% (f) Now for every frame:-
% i. Warp and crop part of frame based upon the updated parameters of affine
% matrix.
% ii. Calculate the error by subtracting the above patch from template patch.
% iii. Compute gradients (tip: try smoothing the gradients)
% iv. Compute the Jacobian, Gradient and Hessian and update the parameters of
% motion model.




	sigma = 3;
	%Make derivatives kernels
	[xder,yder]=ndgrid(floor(-3*sigma):ceil(3*sigma),floor(-3*sigma):ceil(3*sigma));
	DGaussx=-(xder./(2*pi*sigma^4)).*exp(-(xder.^2+yder.^2)/(2*sigma^2));
	DGaussy=-(yder./(2*pi*sigma^4)).*exp(-(xder.^2+yder.^2)/(2*sigma^2));
	% Filter the images to get the derivatives
	Ixgr = imfilter(nextFrame,DGaussx,'conv');
	Iygr = imfilter(nextFrame,DGaussy,'conv');

	loopnum = 0;
	deltap = 5;
	while ( norm(deltap) > deltapthreshold)
	    %THE KLT ALGO


	    % Source - http://crcv.ucf.edu/courses/CAP5415/Fall2013/Lecture-10-KLT.pdf

		% Algorithm (KLT‐Baker et. al.)
		% 1. Warp with
		% 2. Subtract from
		% 3. Compute gradient
		% 4. Evaluate the Jacobian
		% 5. Compute steepest descent
		% 6. Compute Inverse Hessian
		% 7. Multiply steepest descend with error
		% 8. Compute
		% 9. Update parameters

	    Wp = [ 1+p(1) p(3) p(5); p(2) 1+p(4) p(6)];
	    % Iwarped = affine_transform_2d_double(nextFrame,x,y,Wp);
	    % tform = affine2d(Wp)
	    Iwarped = affine_transform_2d_double(nextFrame,x,y,Wp);
	    Idiff= Template - Iwarped;
	    if((p(5)>(size(nextFrame,1))-1)||(p(6)>(size(nextFrame,2)-1))||(p(5)<0)||(p(6)<0))
	    	break; 
	    end
	    Ix =  affine_transform_2d_double(Ixgr,x,y,Wp);
	    Iy = affine_transform_2d_double(Iygr,x,y,Wp);
	    WJacobianx=[x(:) zeros(size(x(:))) y(:) zeros(size(x(:))) ones(size(x(:))) zeros(size(x(:)))];
	    WJacobiany=[zeros(size(x(:))) x(:) zeros(size(x(:))) y(:) zeros(size(x(:))) ones(size(x(:)))];
	    
	    Isteep=zeros(numel(x),6);
	    for j1=1:numel(x),
	        WJacobian=[WJacobianx(j1,:); WJacobiany(j1,:)];
	        Gradient=[Ix(j1) Iy(j1)];
	        Isteep(j1,1:6)=Gradient*WJacobian;
	    end
	    H=zeros(6,6);
	    for j2=1:numel(x)
	    	H=H+ Isteep(j2,:)'*Isteep(j2,:);
	    end
	    total=zeros(6,1);
	    for j3=1:numel(x)
	    	total=total+Isteep(j3,:)'*Idiff(j3);
	    end
	    deltap=H\total;
	    p = p + deltap';


	    %Break if it is not convergence for more than 100 loop, and consider it as convergence
	   	loopnum= loopnum + 1;
	    if(loopnum > maxloopnum)
	        break;
	    end

	end
	finalp = p;
end
