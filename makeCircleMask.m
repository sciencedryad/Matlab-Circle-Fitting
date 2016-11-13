function circleMask=makeCircleMask(R)
% make circle mask of radius R (can be non-integer)
%   returns double matrix with 1 inside of circle, 0 else

Rpix=round(R);
diam=2*Rpix+1;
Rsquare=R*R;
X = ones(diam,1)*(-Rpix:Rpix); Y = (-Rpix:Rpix)'*ones(1,diam);
%diamSmall=round(diam/10);
%X = ones(diamSmall,1)*(-Rpix:10:Rpix); Y = (-Rpix:10:Rpix)'*ones(1,diamSmall);
Z = X.^2 + Y.^2;

%mesh(Z);
circleMask = zeros([diam diam]);
%circleMask(find(Z <= R^2)) = 1;
circleMask(Z<=Rsquare) = 1;
%figure(1),imshow(circleMask);