% define the objective function: J(x,theta) returns the sum of all the
% errors for each user and movie combination prediction/observation pair
function j = collabFilterSqErr(x,theta,y,r)
    lmd = 0.5; % changes the balance between simplicity and accuracy
    sqerr = 0.5*sum(sum(r.*((x*theta'-y).^2)));
    xreg = (lmd/2.0)*sum(sum(x.^2)); % Pulls J toward simpler solutions
    thetareg = (lmd/2.0)*sum(sum(theta.^2)); % Pulls J toward simpler solutions
    j = sqerr + xreg + thetareg;
end

