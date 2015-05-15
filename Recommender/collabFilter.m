function [p,trainerr,testerr,x,theta,Y,r,mu] = collabFilter(r,Y,n)
% grad_descent.m demonstrates how the gradient descent method can be used
% to solve a simple unconstrained optimization problem. Taking large step
% sizes can lead to algorithm instability. The variable alpha below
% specifies the fixed step size. Increasing alpha above 0.32 results in
% instability of the algorithm. An alternative approach would involve a
% variable step size determined through line search.
%
% This example was used originally for an optimization demonstration in ME
% 149, Engineering System Design Optimization, a graduate course taught at
% Tufts University in the Mechanical Engineering Department. A
% corresponding video is available at:
% 
% http://www.youtube.com/watch?v=cY1YGQQbrpQ
%
% Author: James T. Allison, Assistant Professor, University of Illinois at
% Urbana-Champaign
% Date: 3/4/12

if nargin==0
    %Create a matrix for the user ratings
    nu = 50; %number of users
    nm = 50; %number of movies
    n = 3; %number of features

    %r = round(rand(nm, nu)); %Movies that were rated by users
    r = ones(nm, nu); % All movies were rated by all users - should produce near 0 error
    r(randperm(numel(r), ceil(numel(r)*0.9))) = 0;
    nk = 3;
    x = randnclust(nk,nm,n,0.1,repmat([0 1],n,1))'; % Use random centroids
    theta = randnclust(nk,nu,n,0.1,repmat([0 1],n,1))';
    Y = x*theta';
    Y = (Y-min(min(Y)))/(max(max(Y))-min(min(Y))) * 5;
elseif nargin == 2
    if size(Y) ~= size(r),
        error('Existence and Observed ratings matrices must be of equal size')
    end
    [nm, nu] = size(Y);
    n = 4;
elseif nargin == 3
    if size(Y) ~= size(r),
        error('Existence and Observed ratings matrices must be of equal size')
    end
    [nm, nu] = size(Y);
else
     error('Incorrect number of input arguments.')    
end

% Set up parameters
tol = 1e-6; % termination tolerance
maxiter = 1000; % maximum number of allowed iterations
dxmin = 1e-6; % minimum allowed perturbation
alpha = 0.1/mean([nu nm]); % step size ( 0.33 causes instability, 0.2 quite accurate)
% initialize gradient norm, optimization vector, iteration counter, perturbation
gnorm_x = inf; gnorm_theta = inf; niter = 1; dx = inf; dtheta = inf; 

% Initialize x and theta to be small random values
x = rand(nm, n); % Feature values for each movie [0,1]
theta = rand(nu, n); % Feature preferences for each user [0,5]


% Normalize the ratings by subtracting the mean
numRatings = sum(r,2);
numRatings(~numRatings)=1; % Prevent division by zero
mu = sum(Y.*r,2)./numRatings; % Get the average rating
mu = repmat(mu, 1, nu); % Repeat the mean along the columns to match size(Y)

y = Y - mu; % Subtract the mean
% y = Y;

% Uncomment for testing

rndx = x;
rndtheta = theta;
allJ = zeros(maxiter/10,1);
allJChance = zeros(maxiter/10,1);
maxx = zeros(maxiter/10,1);
maxtheta = zeros(maxiter/10,1);

% gradient descent algorithm:
while and(and(gnorm_x>=tol, gnorm_theta>=tol), and(niter <= maxiter, and(dx >= dxmin, dtheta >= dxmin)))
    
    % calculate gradient:
    [d_x,d_theta] = collabFilterSqErrGrad(x,theta,y,r);
    gnorm_x = norm(d_x);
    gnorm_theta = norm(d_theta);
    
    % take step:
    xnew = x - alpha*d_x;
    thetanew = theta - alpha*d_theta;

    % Uncomment for testing
    
    % Compare the gradient direction step to a random step with the same
    % magnitude
    rndd_x = randn(size(x));
    rndd_x = (rndd_x/norm(rndd_x))*gnorm_x;
    rndd_theta = randn(size(theta));
    rndd_theta = (rndd_theta/norm(rndd_theta))*gnorm_theta;
    % take a random step
    rndx = rndx-alpha*rndd_x;
    rndtheta = rndtheta-alpha*rndd_theta;
    

    % Error check step
    if ~isfinite(xnew),
        display(['Number of iterations: ' num2str(niter)])
        plot(allJ);
        error('x is inf or NaN')
    end
    if ~isfinite(thetanew),
        display(['Number of iterations: ' num2str(niter)])
        plot(allJ);
        error('theta is inf or NaN')
    end
    
    % update termination metrics    
    dx = rand*alpha; %absolute step size
    dtheta = rand*alpha;
    niter = niter + 1;
    x = xnew;
    theta = thetanew;
    
    % Uncomment for testing
   
    % Store the avg error (J value) for each iteration and plot it against niter to
    % see if the algorithm gets closer to the minimum each iteration
    if rem(niter,10)==0,
        maxx(niter/10) = max(max(d_x));
        maxtheta(niter/10) = max(max(d_theta));
        J = collabFilterSqErr(x,theta,y,r);
        Chance = collabFilterSqErr(rndx,rndtheta,y,r);
        allJ(niter/10) = J;
        allJChance(niter/10) = Chance;
    end
    
end

% Uncomment for testing
% subplot(2,2,1);
% plot(allJ); title('Grad Descent'); xlabel('Iterations'); ylabel('Training Error');
% subplot(2,2,2);
% plot(allJChance); title('Chance'); xlabel('Iterations'); ylabel('Training Error');
% subplot(2,2,3);
plot([allJ allJChance]); title('Grad Descent vs Random Step');
xlabel('Iterations')
ylabel('Error')

figureHandle = gcf;
%# make all text in the figure to size 14 and bold
set(findall(figureHandle,'type','text'),'fontSize',18)

% Once theta and x are learned, predict all ratings for all movie, user
% pairs

p = x*theta' + mu; % Predict and add back the mean
% err = collabFilterSqErr(x,theta,y,r);
trainerr = (p-Y).*r;
testerr = (p-Y).*(~r);
% avgErr = sum(sum(abs(err)))/sum(sum(r));

end


