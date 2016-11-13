function  [xc,yc,R,circleImage]=fitCircleViaRandomArcs(binaryColonyPic,showFig,...
    nTrials,arclengthFraction,nRand,circleThickness)
% Fits a circle to the single component in binaryColonyPic.
% Methods: pick a random number of points (plus some arclength around them)
%    on the circle arc and fit a circle to these. Repeat this 
%    and then take the radius that appears most often. 
%    This method allows to fit to a circle boundary with additional bulges 
%    outside or inside.
% Returs: center (xc,yc), radius R, and 
%    circle drawn on image in circleImage (same size as binaryColonyPic)
% Parameters:
%   showFig =1 show pictures, =0 don't show pictures
%   nTrials=number of times to pick random points and fit, usually ~500 
%   arclengthFraction = length of arc to take around each random point,
%     usually ~1/5
%   nRand=number of random arcs on circle to pick

%==============================
% parameters    
%==============================
    %nTrials=500; % number of attemps to pick points and fit circle
    %nRand=3;  % number of random arcs on circle to pick
        % that's actually not the ful truth since the circle boundary is
        % not given as a continuous trace but as a list of points in
        % ascending order of indices, so nRand=1 usually gives 2 arcs.
    %arclengthFraction=1/5; % arclength fraction of circle boundary    
    nbins=ceil(nTrials/4); % number of bins in radius histogram
    debug=0; % show figure in each trial


%figure(100),imshow(binaryColonyPic,'InitialMagnification',25),title('binary colony');


% get starting values for the circle fit
    colonyProps  = regionprops(binaryColonyPic, 'Centroid','Area');
    xcStart=colonyProps.Centroid(1);
    ycStart=colonyProps.Centroid(2);
    RStart=1.*sqrt(colonyProps.Area/pi);


% get colony boundary
     sizing=size(binaryColonyPic);
     colonyBoundary=edge(binaryColonyPic);
 
% %get colony boundary (as a trace!)
%     [x y]=find(colonyBoundary==1);
%     xTraced=[];yTraced=[];
%     xLeft=x;yLeft=y;
%     xTrace=x(1);yTrace=y(1);
%     xTraced=[xTraced xTrace];yTraced=[yTraced yTrace];
%     xLeft(1)=[];yLeft(1)=[];
%     while(~isempty(xLeft))    
%         %find the next point 
%             diffVec=abs(yLeft-yTrace)+abs(xLeft-xTrace);
%             [diffToAdd indexTrace]=min(diffVec);
%         %add point to the traced sector    
%               xTrace=xLeft(indexTrace); yTrace=yLeft(indexTrace);  
%               xTraced=[xTraced xTrace]; 
%               yTraced=[yTraced yTrace]; 
%         %remove point, as well as all points with larger x values, from list of points to look at
%             xLeft(indexTrace)=[];
%             yLeft(indexTrace)=[];
%     end
%     indices=sub2ind(sizing,xTraced,yTraced);
%     colonyBoundaryTraced=zeros(sizing);
%     for i=1:length(indices)
%         colonyBoundaryTraced(indices(i))=1;
%     end

    indices=find(colonyBoundary==1);
    boundaryLength=length(indices);
    if(showFig==1)
        figure(101),imshow(colonyBoundary,'InitialMagnification',25),title('colony boundary for random arc circle fitting');
    end

% initialize
    l=ceil(boundaryLength*arclengthFraction); % length of arcs
    assert(nRand<=boundaryLength);
    if(mod(l,2)==0);l=l+1;end
    spaceAround=linspace(1,l,l)-(l+1)/2;
    radiiList=zeros(1,nTrials);
    xcList=zeros(1,nTrials);
    ycList=zeros(1,nTrials);
 
% tic
for i=1:nTrials
%    disp(num2str(i));

    % select random points and arcs around them
        rands=floor((boundaryLength+1)*rand(1,nRand));
        randomNumbers=zeros(1,nRand);
        for j=1:nRand;randomNumbers((j-1)*l+1:j*l)=rands(j)+spaceAround;end
        randomNumbers=mod(randomNumbers,boundaryLength)+1;
        tryIndices=indices(randomNumbers);
        [rows cols] = ind2sub(sizing, tryIndices);
        XY=[rows cols];
    
    % fit circle    
        circleInfo=CircleFitLevenbergMarquardt(XY,[ycStart xcStart RStart]);
            xc=circleInfo(2);yc=circleInfo(1);R=circleInfo(3);
    
    if(debug==1)        
        circleImage = drawCircleBoundaryOnImage(zeros(sizing),xc,yc,R,1);
        ITryBoundary=zeros(sizing);
        ITryBoundary(tryIndices)=1;
        se = strel('disk',3);
        ITryBoundary=imdilate(ITryBoundary,se); 
        plotColorPic(i,binaryColonyPic,circleImage,ITryBoundary,45);
    end
    
    % save results to plot later
    xcList(i)=xc;
    ycList(i)=yc;
    radiiList(i)=R;
    
end
% toc


% make histogram of radii
    [counts rBins]=hist(radiiList,nbins);
    if(showFig==1)
        figure(102),plot(rBins,counts,'rd-');
        xlabel('radius r');ylabel('counts');
    end
    
% find maximum of histogram    
    [maxi maxpos]=max(counts);
    rMax=rBins(maxpos(1));
    binSize=mean(diff(rBins));
    
% find all values within the maximum bin and take their average as the result    
    selectVec=logical((radiiList>rMax-binSize/4).*(radiiList<rMax+binSize/4));
    R=mean(radiiList(selectVec));
    xc=mean(xcList(selectVec));
    yc=mean(ycList(selectVec));
    
% plot results    
    circleImage = drawCircleBoundaryOnImage(zeros(sizing),xc,yc,R,circleThickness);
    if(showFig==1)
        plotColorPic(103,binaryColonyPic,circleImage,zeros(sizing),45,'fitted circle on colony mask from random arc circle fitting');
    end
