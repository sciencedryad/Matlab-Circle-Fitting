function circleimage = drawCircleOnImage(IIn,xc,yc,R)
% draws a circle (filled) with center (xc,yc) and radius R onto the image IIn
% - allows circle to go beyond image boundaries

    xc=round(xc);yc=round(yc);Rpix=round(R);    

% get circle mask    
    circleimage=IIn;
    %figure(10),imshow(circleimage);
    circleMask=makeCircleMask(R);
    %circleMask=edge(circleMask);

%=================================
% draw circle mask on image    
%=================================
    circleSizeX=size(circleMask,1);circleSizeY=size(circleMask,2);
    imagesizeY=size(circleimage,1);imagesizeX=size(circleimage,2);
    
    x1 = xc-Rpix; y1 = yc-Rpix; 
            % upper left corner of circleMask in target image
    x2 = x1 + circleSizeX-1; y2 = y1 + circleSizeY-1;
            % lower right corner of circleMask in target image
%     disp(['image size = ',num2str(size(circleimage)) ]);
%     disp(['x1, x2 = ',num2str(x1),', ',num2str(x2)]);
%     disp(['y1, y2 = ',num2str(y1),', ',num2str(y2)]);
%    circleimage(y1:y2, x1:x2) = circleimage(y1:y2, x1:x2) + circleMask ;

% only plot the part of the circle that fits onto the image
    x1Setoff=0;x2Setoff=0;y1Setoff=0;y2Setoff=0;
    if(x1<1); x1Setoff=1-x1;end
    if(y1<1); y1Setoff=1-y1;end
    if(x2>imagesizeX); x2Setoff=imagesizeX-x2;end
    if(y2>imagesizeY); y2Setoff=imagesizeY-y2;end

    
    circleimage  (y1+y1Setoff:y2+y2Setoff, x1+x1Setoff:x2+x2Setoff)... 
    = circleimage(y1+y1Setoff:y2+y2Setoff, x1+x1Setoff:x2+x2Setoff)...
    + circleMask ( 1+y1Setoff:circleSizeY+y2Setoff,  1+x1Setoff:circleSizeX+x2Setoff);


    %figure(40),imshow(circleimage,'InitialMagnification',25);    
