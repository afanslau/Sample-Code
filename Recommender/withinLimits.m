% Adam Fanslau
% Returns the linear indices of the points matrix whose values are outside
% the specified limits
function [w, over, under] = withinLimits(points,limits)
    [nd,np] = size(points);
    if nd~=size(limits,1)
        error('Points and limits must have the same number of rows');
    end
    % Modify the distances to keep all the points within the limits while maintaining the std
    startEdgeDist = points - repmat(limits(:,1),1,np); % Distance from each point to its edge.
    % For all the points where this is negative or 0 (on or beyond the limit), negate the dist
    endEdgeDist = repmat(limits(:,2),1,np) - points; 
    under = find(startEdgeDist<=0)';
    over = find(endEdgeDist<=0)';
    w = [under over];
end