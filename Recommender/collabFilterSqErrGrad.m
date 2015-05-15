% define the gradient of the objective
function [d_x,d_theta] = collabFilterSqErrGrad(x, theta, y,r) % g is a 2xn matrix where n is the number of features
    % row 1 is the x derivative, and row 2 is the theta derivative 
    lmd = 0.5; %Lambda. How does this parameter affect the algorithm?
    d_x = (r.*(x*theta'-y))*theta + lmd*x;
    d_theta = (r.*(x*theta'-y))'*x + lmd*theta;
    % Returns the partial derivatives of J(x) with respect to each
    % component of x (i.e, each feature)
end