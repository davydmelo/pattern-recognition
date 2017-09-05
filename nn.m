clc; clear; close all;

labels = ['r'; 'b'; 'g'];

load('datasets/three-balls/threeballs.mat');

point = 16 * (rand(2,1) - 0.5);

centroid1 = sum(data(1:2,1:100),2) / size(data(1:2,1:100),2);
centroid2 = sum(data(1:2,101:200),2) / size(data(1:2,101:200),2);
centroid3 = sum(data(1:2,201:300),2) / size(data(1:2,201:300),2);

plot(data(1,1:100), data(2,1:100), 'rx'); hold on;
plot(data(1,101:200), data(2,101:200), 'bx');
plot(data(1,201:300), data(2,201:300), 'gx');

plot(point(1,1), point(2,1), 'k*');

plot(centroid1(1,1), centroid1(2,1), 'r*');
plot(centroid2(1,1), centroid2(2,1), 'b*');
plot(centroid3(1,1), centroid3(2,1), 'g*');

plot([point(1,1) centroid1(1,1)],[point(2,1) centroid1(2,1)],'r');
plot([point(1,1) centroid2(1,1)],[point(2,1) centroid2(2,1)],'b');
plot([point(1,1) centroid3(1,1)],[point(2,1) centroid3(2,1)],'g');

axis([-8 8 -8 8]);
title('Nearest Neighbor Classifier');
xlabel('X1');
ylabel('X2');

distances = [];
tic;
for i = 1:length(data)
    diff = data(1:2,i) - point;
    dist = sqrt(diff' * diff);
    distances = [distances dist];
end
time = toc

labels(data(3, find(min(distances) == distances)),:)