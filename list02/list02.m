clc, clear, close all;

data = load('../datasets/vertebral_column/column_2C.dat');
data = data(:,1:6)';

% Matlab
C = cov(data',1);