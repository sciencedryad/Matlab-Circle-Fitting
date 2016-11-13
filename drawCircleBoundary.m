function circleimage = drawCircleBoundary(IIn,xc,yc,R)
% draws a circle (boundary) with center (xc,yc) and radius R onto the image IIn
%    and returns it as image circleimage (same size and type as IIn)
%    uses polar coordinates -> don't getmany points where the circle passes
%    the axes

    circleimage=IIn;

    phi=linspace(0,2*pi,10000)';  % list of angles
    xe = round(R*cos(phi)+xc); ye = round(R*sin(phi)+yc); % points on circle
    for i=1:size(xe),
       circleimage(ye(i),xe(i))=1;  % plot points
    end
    %figure(5),imshow(circleimage,'InitialMagnification',25);

