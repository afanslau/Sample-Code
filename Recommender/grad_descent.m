




function [xopt,fopt,niter,gnorm,dx] = grad_descent(varargin)
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
    % define starting point
    x0 = [3 3]';
elseif nargin==1
    % if a single input argument is provided, it is a user-defined starting
    % point.
    x0 = varargin{1};
else
    error('Incorrect number of input arguments.')
end

% termination tolerance
tol = 1e-6;

% maximum number of allowed iterations
maxiter = 1000;

% minimum allowed perturbation
dxmin = 1e-6;

% step size ( 0.33 causes instability, 0.2 quite accurate)
alpha = 0.1;

% initialize gradient norm, optimization vector, iteration counter, perturbation
gnorm = inf; niter = 0; dx = inf;



%Create a matrix for the user ratings
nu = 5; %number of users
nm = 4; %number of movies
n = 3; %number of features

r = round(rand(nm, nu)); %Movies that were rated by users
y = randi([0 5], nm, nu); %Rating for movie i, user j


% Initialize x and theta to be small random values
%These will be learned
x = rand(nm, n) * 0.25; %Create the feature matrix
theta = rand(nu, n) * 0.25; %Create the preference matrix. Should users be rows or columns?


% Define objective function and its derivative

% define the objective function: J(x,theta) returns the sum of all the
% errors for each user and movie combination prediction/observation pair
function j = f(x,theta)
    lmd = 0.5;
    j = 0;
    for i = 1:nm,
        for j = 1:nu,
            if r(i,j) == 1,
                sqerr = 0.5*((x(i,:)*theta(j,:)'-y(i,j))^2);
                j = j + sqerr;
            end 
        end
        % Regularization term. Not sure exactly what this is for
        j = j + (lmd/2.0)*sum(x(i,:).^2);
    end
    
    %Theta Regulatization term
    for j = 1:nu,
        j = j + (lmd/2.0)*sum(theta(j,:).^2);
    end
end

% define the gradient of the objective
function g = grad(x, theta) % g is a 2xn matrix where n is the number of features
    % row 1 is the x derivative, and row 2 is the theta derivative 
    
    lmd = 0.5; %Lambda. How does this parameter affect the algorithm?
    
    d_theta = 0;
    d_x = 0;
    for j = 1:nu,
        for i = 1:nm,
            if r(i,j)==1,
                % These equations come from video 4 7:47
                % d_x is a row vector specifying the partial derivative for
                % each feature? I think
                if i==1,
                    d_x = d_x + (x(i,:)*theta(j,:)'-y(i,j))*theta(j,:) + lmd*x(i,:);
                end
                if j == 1,
                    d_theta = d_theta + (x(i,:)*theta(j,:)'-y(i,j))*x(i,:) + lmd*theta(j,:);
                end
            end
        end
    end
    
    g = [d_x; d_theta];
    % Returns the partial derivatives of J(x) with respect to each
    % component of x (i.e, preferences and feature scores)
end


 
% % plot objective function contours for visualization:
% figure(1); clf; ezcontour(f,[-5 5 -5 5]); axis equal; hold on


% gradient descent algorithm:
while and(gnorm>=tol, and(niter <= maxiter, dx >= dxmin))
    % calculate gradient:
    g = grad(x,theta);
    gnorm = norm(g);
    % take step:
    xnew = x - alpha*g(1,:);
    thetanew = theta - alpha*g(2,:);
    % check step
    if ~isfinite(xnew)
        display(['Number of iterations: ' num2str(niter)])
        error('x is inf or NaN')
    end
    % plot current point
%     plot([x(1) xnew(1)],[x(2) xnew(2)],'ko-')
%     refresh
    % update termination metrics
    niter = niter + 1;
    dx = norm(xnew-x);
    x = xnew;
    
end
xopt = x;
fopt = f2(xopt);
niter = niter - 1;

% Once theta and x are learned, predict all ratings for all movie, user
% pairs
p = x*theta';
disp(y)
disp(p)

end






