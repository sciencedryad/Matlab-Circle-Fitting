function circleimage = drawCircleBoundaryOnImage(IIn,yc,xc,R,circleThickness)
% - draws a circle (boundary) with center (xc,yc) and radius R onto the image IIn
% - allows circle to go beyond image boundaries
% - allows circle center to be outside image

%disp(['R=',num2str(R),',xc=',num2str(xc),', yc=',num2str(yc)]);
%disp(['picture size = ',num2str(size(IIn))]);


% plot circle
    circleimage=zeros(size(IIn));
    for i=1:size(IIn,1)
        for j=1:size(IIn,2)
            x=i-xc;
            y=j-yc;
            if(x*x+y*y<=R*R)
                circleimage(i,j)=1;
            end
        end
    end
  % get boundary of circle  
    circleimage=edge(circleimage);
    %circleimage(round(xc),round(yc))=1;
  % make circle thicker
    if(circleThickness>1)
        se = strel('disk',circleThickness);
        circleimage=imdilate(circleimage,se);      
    end
  % put circle on image  
    circleimage=circleimage+IIn;




%   % put the circle center on empty image 
%     circleimage=zeros(size(IIn));
%     circleimage(round(xc),round(yc))=1;
%   % plot circle around center  
%     Idist=bwdist(circleimage);
%     circleimage(Idist<=R)=1;
%   % get boundary of circle  
%     circleimage=edge(circleimage);
%   % make circle thicker
%     if(circleThickness>1)
%         se = strel('disk',circleThickness);
%         circleimage=imdilate(circleimage,se);      
%     end
%   % put circle on image  
%     circleimage=circleimage+IIn;

    %figure(40),imshow(circleimage,'InitialMagnification',25);    
  % output for check
    %plotColorPic(1,circleimage,IIn,zeros(size(IIn)),40);
    %%figure(2),imshow(Idist,[],'InitialMagnification',40)
    %%figure(3),imshow(I,[],'InitialMagnification',40)    
