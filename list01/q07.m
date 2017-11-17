% Apaga o workspace, limpa o console e fecha todas as janelas
clear, clc, close all;

% Matriz de covari�ncia desejada
C = [1 -0.6 0.4; -0.6 9 -0.5; 0.4 -0.5 4];

% Gera os dados a partir da matriz de covari�ncia
r = mvnrnd([0 0 0], C, 100);
x2 = r(:,2);
x3 = r(:,3);

% M�dias, desvios padr�es e coeficiente de correla��o
m2 = mean(x2);
m3 = mean(x3);
s2 = sqrt(C(2,2));
s3 = sqrt(C(3,3));
rho23 = C(2,3)/(s2*s3);

% Coeficiente angular e intercepto da reta
a = (s3/s2) * (rho23);
b = m3 - a * m2;
t = -9:0.5:9;

% Lugar geom�trico das curvas de contorno
F = @(x2,x3) ((x2 - m2)^2)/s2^2 + ...
             ((x3 - m3)^2)/s3^2 - ...
             (2 * (rho23) * (x2 - m2) * (x3 - m3))/(s2 * s3)

% Exibi��o e formata��o dos gr�ficos
hold on;
scatter(x2, x3,'k');
ezcontour(F, [-8 8 -6 6]);
plot(t, a * t + b);
title('Gr�fico de dispers�o de x_{2} vs x_{3}')
axis([-10 10 -10 10])