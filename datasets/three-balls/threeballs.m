clc; clear; close all;

cloud1 = randn(2,100);
cloud2 = 4 + randn(2,100);
cloud3 = -4 + randn(2,100);

cloud1 = [cloud1; 1*ones(1,size(cloud1,2))];
cloud2 = [cloud2; 2*ones(1,size(cloud2,2))];
cloud3 = [cloud3; 3*ones(1,size(cloud3,2))];

data = [cloud1 cloud2 cloud3];

save('threeballs.mat', 'data');