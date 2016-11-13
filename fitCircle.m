function [xc,yc,R,circleImage]=fitCircle(binaryNoisyCircle,circleThickness)
% fits a circle to the supposed circle in binary image binaryNoisyCircle
%    returns coordinates (xc,yc) of circle center, circle radius R,
%    and binary image of same size as binaryNoisyCircle with circle on it
% circleThickness determines width of circle line in output image
%    circleImage

% prepare the pixel indices of the circle boundary
    noisyCircleBoundary=edge(binaryNoisyCircle); 
    %noisyCircleBoundary=imdilate(noisyCircleBoundary,strel('disk',circleThickness));
    [rows cols]=find(noisyCircleBoundary==1);
    XY=[rows cols];
    %figure(11),imshow(noisyCircleBoundary,'InitialMagnification',35);

%================================
% fit circle with Pratt's method
%================================
    %disp('Will now use CircleFitByPratt');
    circleInfo=CircleFitByPratt(XY);
        % Pratt's method this is a good algebraic circle fit method. 
        % It's very fast and very stable, but slightly less accurate than
        % Levenberg-Marquardt, especially when there is only a part of the
        % circle boundary available (i.e., an arc), or the noise is
        % 'biased' on some circle sides.
        xc=circleInfo(2);yc=circleInfo(1);R=circleInfo(3);
        %disp(['  after Pratt circle fit:              R=',num2str(R),', xc=',num2str(xc),', yc=',num2str(yc)]);

    
%================================
% fit circle with Levenberg-Marquardt
%================================
    % use initial guess from Pratt fit: use above xc,yc,R
    % use initial guess from image size
        %xc=0.5*size(binaryNoisyCircle,1);yc=0.5*size(binaryNoisyCircle,2);R=0.25*min(xc,yc);
    %disp('Will now use CircleFitLevenbergMarquardt');
    circleInfo=CircleFitLevenbergMarquardt(XY,[yc xc R]);
        xc=circleInfo(2);yc=circleInfo(1);R=circleInfo(3);
        % This is a very good geometric circle fit method.
        % It's very accurate, but requires initial guesses of the circle
        % parameters. If these are bad, it will not work. 
        % With a good initial guess, the method is very robust against
        % noise and having only a circle arc.
    %disp(['  after LevenbergMarquardt circle fit: R=',num2str(R),', xc=',num2str(xc),', yc=',num2str(yc)]);
    
% make circle mask of radius R
    %circleMask=makeCircleMask(R);
    
% draw circle on image
    Izeros=zeros(size(binaryNoisyCircle));
    %circleimage = drawCircleOnImage(Izeros,xc,yc,R);
    circleImage = drawCircleBoundaryOnImage(Izeros,xc,yc,R,circleThickness);
    %figure(11),imshow(circleImage);    
    
% % drawing for diagnosis    
%     sizing=[size(binaryNoisyCircle) 3];
%     Icolor=zeros(sizing);
%     Icolor(:,:,1)=binaryNoisyCircle;
%     Icolor(:,:,2)=circleImage;
%     Icolor(:,:,3)=noisyCircleBoundary;
%     figure(11),imshow(Icolor);
    