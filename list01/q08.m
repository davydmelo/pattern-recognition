% Apaga o workspace, limpa o console e fecha todas as janelas
clear, clc, close all;

x1 = [1;2];
x2 = [-1;3];
x3 = [1;-1];
X = [x1 x2 x3];
N = 3;

% Vetor médio
m = (x1 + x2 + x3)/N;

% Método 1
Cx1 = ((x1 - m)*(x1 - m)' + (x2 - m)*(x2 - m)' + (x3 - m)*(x3 - m)')/(N)

% Método 2
Rx2 = (X*X')/(N);
Cx2 = Rx2 - m*m'

% Método 3
M = repmat(m,1,3);
Cx3 = ((X - M)*(X - M)')/(N)

% Método 4 (MATLAB)
Cx4 = cov(X',1)