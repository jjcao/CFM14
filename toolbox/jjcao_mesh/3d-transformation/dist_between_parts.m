function [dist1, dist2] = dist_between_parts(v1, v2)
dist1 = distBetweenParts(v1, v2);
dist2 = distBetweenParts(v2, v1);

function dist = distBetweenParts(v1, v2)
n1 = size(v1,1);
n2 = size(v2,1);
dist = 0;
for i = 1:n1
    minErr = 999999;
    pt1 = v1(i,:);
    for j = 1:n2
        pt2 = v2(j,:);
        tmp = sqrt( sum( (pt1-pt2).^2 ) );
        if tmp < minErr
            minErr = tmp;
        end
    end
    dist = dist + minErr;
end
dist = dist/n1;
