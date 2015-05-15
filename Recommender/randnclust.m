%{
Adam Fanslau
A function that creates a clustered distribution of points

k - number of clusters

n - number of output points

ndim - size of vector space

std - standard deviation of point-centroid distance

limits - matrix of size [ndim 2] specifiying the start and end cutoff
    default limits are twice the std on each side for ever dimension

centroids - matrix of size [ndim k] where column vectors specify the
centers of each cluster
    default centroids are random points within the limits

Example usage
C = randnclust(3,1000,2,1,[0 10; 0 20],[2 3 4; 1 1 1]);
%}
function [C, centroids, limits] = randnclust(k,n,ndim,std,limits,centroids)

% Used for testing - 1 is for testing, 0 is for production
testingFlag=0;
defaultargs = nargin==0 && testingFlag;
if defaultargs,
    k=3; n=1000; ndim=3; std=1;
end

% Invalid args
if (nargin<3 && ~defaultargs) || nargin>6
    error('Invalid number of arguments');
end

% Set the std if not specified
if nargin==3
    std=1;
end

% Calculate the initial point-centroid distances
dist = std*randn(ndim,n);

% Set the limits and centroids if not specified
if nargin<5
    % Eventually, create the limits so that all points fit into the limits
    limits = repmat([-2*std 2*std], ndim, 1); 
end
if nargin<6
    % Define random centroid points within the limits (evenly spaced?)    
    centroids = repmat(limits(:,1),1,k) + repmat(limits(:,2)-limits(:,1),1,k).*rand(ndim,k);
else % Centroids are specified
    % Verify the size
    if ~isequal(size(centroids),[ndim,k])
        error('Size of centroids must be [ndim k]');
    end
    % Verify the centroids are within the limits
    dum = withinLimits(centroids,limits);
    if len(dum)>0
        error('Centroids must lie within the specified limits');
    end
end

if n<k,
    error('Number of points must be greater than or equal to the number of clusters');
end

% Initialize points in the distribution at the centroids
nPerK = floor(n/k); % What if I want clustered points with different ratios for each centroid? This could be acheived by concatenating clusters
remainder = n - nPerK*k;
C = repmat(centroids,1,nPerK);
C = [C C(:,1:remainder)];

% Modify the distances to keep all the points within the limits while maintaining the std
tempC = C + dist;
[dum, underLimIndx,overLimIndx] = withinLimits(tempC,limits);
dist([underLimIndx,overLimIndx]) = -dist([underLimIndx,overLimIndx]);

% Disperse the points away from the centroids
C = C + dist;

% Testing
if testingFlag,
   % Plot results
   if ndim==3,
       scatter3(C(1,:),C(2,:),C(3,:));
   elseif ndim==2,
       scatter(C(1,:),C(2,:));
   end
   title([num2str(k) ' Normally Distributed Clusters, SD=' num2str(std)]);
   xlabel('Feature 1');
   ylabel('Feature 2');
   zlabel('Feature 3');
   set(findall(gcf,'type','text'),'fontSize',18); %gcf - get current figure
end
end


% Normalize the points so they are within the given limits


% If the point to centroid distance is greater than the edge to centroid
% distance, take the negative distance, because it is just as probable
