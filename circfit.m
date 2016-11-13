function   [xc,yc,R] = circfit(x,y)
% fits circle to points x,y, returns center point (yc,xc) and radius R
%
% x,y are column vectors where (x(i),y(i)) is a measured point
%
%  fits a circle in x,y plane in a more accurate (less prone to ill condition )
%  procedure than circfit2 but using more memory
%  a is vector of coeficient describing the circle's equation
%      x^2+y^2+a(1)*x+a(2)*y+a(3)=0

   x=x(:); y=y(:);
   a=[x y ones(size(x))]\(-(x.^2+y.^2));
   xc = -.5*a(1);
   yc = -.5*a(2);
   R  =  sqrt((a(1)^2+a(2)^2)/4-a(3));