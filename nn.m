clc; clear; close all;

labels = ['r'; 'b'; 'g'];

cloud1 = randn(2,100);
cloud2 = 4 + randn(2,100);
cloud3 = -4 + randn(2,100);

point = 16 * (rand(2,1) - 0.5);

centroid1 = sum(cloud1,2) / size(cloud1,2);
centroid2 = sum(cloud2,2) / size(cloud2,2);
centroid3 = sum(cloud3,2) / size(cloud3,2);

cloud1 = [cloud1; 1*ones(1,size(cloud1,2))];
cloud2 = [cloud2; 2*ones(1,size(cloud2,2))];
cloud3 = [cloud3; 3*ones(1,size(cloud3,2))];

data = [cloud1 cloud2 cloud3];

plot(cloud1(1,:), cloud1(2,:), 'rx'); hold on;
plot(cloud2(1,:), cloud2(2,:), 'bx');
plot(cloud3(1,:), cloud3(2,:), 'gx');

plot(point(1,1), point(2,1), 'k*');

plot(centroid1(1,1), centroid1(2,1), 'r*');
plot(centroid2(1,1), centroid2(2,1), 'b*');
plot(centroid3(1,1), centroid3(2,1), 'g*');

plot([point(1,1) centroid1(1,1)],[point(2,1) centroid1(2,1)],'r');
plot([point(1,1) centroid2(1,1)],[point(2,1) centroid2(2,1)],'b');
plot([point(1,1) centroid3(1,1)],[point(2,1) centroid3(2,1)],'g');

distances = [];
for i = 1:length(data)
    diff = data(1:2,i) - point;
    dist = sqrt(diff' * diff);
    distances = [distances dist];
end

labels(data(3, find(min(distances) == distances)),:)