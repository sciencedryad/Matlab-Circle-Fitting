function circleimage = drawCircleOnImage(IIn,yc,xc,R)
% draws a circle (filled) with center (xc,yc) and radius R onto the image IIn
% - allows circle to go beyond image boundaries
% - allows circle center to be outside image

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
% put circle on image  
     circleimage=circleimage+IIn;


%   % put the circle center on empty image 
%     circleimage=zeros(size(IIn));
%     circleimage(round(xc),round(yc))=1;
%   % plot circle around center  
%     Idist=bwdist(circleimage);
%     circleimage(Idist<=R)=1;
%   % put circle on image  
%     circleimage=circleimage+IIn;
%   % output for check
%     %plotColorPic(1,circleimage,IIn,zeros(size(IIn)),40);
%     %%figure(2),imshow(Idist,[],'InitialMagnification',40)
%     %%figure(3),imshow(I,[],'InitialMagnification',40)    
    
    
 
