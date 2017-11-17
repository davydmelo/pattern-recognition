warning('on','all')
clear, clc, close all;
format short g;

R = 100;
P = [0.1 0.2 0.4 0.5 0.6 0.8 0.9];

data = load('../datasets/vertebral_column/column_3C.dat');

RateCls1 = zeros(length(P),R);
RateCls2 = zeros(length(P),R);
RateCls3 = zeros(length(P),R);
RateCls4 = zeros(length(P),R);

% Best Rate, Wrost Rate, Best Confusion Matrix, Wrost Confusion Matrix
bRate1 = 0; wRate1 = 101; bCM1 = []; wCM1 = [];
bRate2 = 0; wRate2 = 101; bCM2 = []; wCM2 = [];
bRate3 = 0; wRate3 = 101; bCM3 = []; wCM3 = [];
bRate4 = 0; wRate4 = 101; bCM4 = []; wCM4 = [];

for p = 1:length(P)

for r = 1:R
    [Xtrain, Ytrain, Xtest, Ytest] = part_data(data, 6, 6, P(p));
    Ntrain = size(Xtrain,2);
    Ntest = size(Xtest,2);

    I1 = find(Ytrain == 1); I2 = find(Ytrain == 2); I3 = find(Ytrain == 3);
    n1 = length(I1); n2 = length(I2); n3 = length(I3);
    X1 = Xtrain(:,I1); X2 = Xtrain(:,I2); X3 = Xtrain(:,I3);
    m1 = sum(X1,2)/n1; m2 = sum(X2,2)/n2; m3 = sum(X3,2)/n3;

    Ci = eye(6);
    Cx = cov(Xtrain');
    Cx1 = cov(X1'); Cx2 = cov(X2'); Cx3 = cov(X3');
    CxP = (n1/Ntrain) * Cx1 + (n2/Ntrain) * Cx2 + (n3/Ntrain) * Cx3; invCxP = inv(CxP);
    CxB = diag(diag(Cx)); invCxB = inv(CxB);

    p1 = n1/Ntrain; p2 = n2/Ntrain; p3 = n3/Ntrain;

    Yp01 = zeros(1,Ntest);
    Yp02 = zeros(1,Ntest);
    Yp03 = zeros(1,Ntest);
    Yp04 = zeros(1,Ntest);

    for i = 1:Ntest
        xn = Xtest(:,i);

        % Caso 1 - Identity case
        gI1 = -(1/2) * (xn - m1)' * (xn - m1);
        gI2 = -(1/2) * (xn - m2)' * (xn - m2);
        gI3 = -(1/2) * (xn - m3)' * (xn - m3);

        %Caso 2 - Pooled case
        gP1 = -(1/2) * (xn - m1)' * invCxP * (xn - m1);
        gP2 = -(1/2) * (xn - m2)' * invCxP * (xn - m2);
        gP3 = -(1/2) * (xn - m3)' * invCxP * (xn - m3);

        %Caso 3 - Individual case (Acima de 60% para 10% dos dados)
        g1 = -(1/2) * (xn - m1)' * inv(Cx1 + eye(size(Cx1))*0.000001) * (xn - m1) - (1/2) * log(det(Cx1)) + log(p1);
        g2 = -(1/2) * (xn - m2)' * inv(Cx2 + eye(size(Cx2))*0.000001) * (xn - m2) - (1/2) * log(det(Cx2)) + log(p2);
        g3 = -(1/2) * (xn - m3)' * inv(Cx3 + eye(size(Cx3))*0.000001) * (xn - m3) - (1/2) * log(det(Cx3)) + log(p3);

         % Abaixo de 40% para 10% dos dados
         %g1 = -(1/2) * (xn - m1)' * inv(Cx1) * (xn - m1) - (1/2) * log(det(Cx1)) + log(p1);
         %g2 = -(1/2) * (xn - m2)' * inv(Cx2) * (xn - m2) - (1/2) * log(det(Cx2)) + log(p2);
         %g3 = -(1/2) * (xn - m3)' * inv(Cx3) * (xn - m3) - (1/2) * log(det(Cx3)) + log(p3);

        %Caso 4 - Naive Bayes case
        gN1 = -(1/2) * (xn - m1)' * invCxB * (xn - m1);
        gN2 = -(1/2) * (xn - m2)' * invCxB * (xn - m2);
        gN3 = -(1/2) * (xn - m3)' * invCxB * (xn - m3);

        Yp01(i) = find([gI1; gI2; gI3] == max([gI1; gI2; gI3]));
        Yp02(i) = find([gP1; gP2; gP3] == max([gP1; gP2; gP3]));
        Yp03(i) = find([g1; g2; g3] == max([g1; g2; g3]));
        Yp04(i) = find([gN1; gN2; gN3] == max([gN1; gN2; gN3]));        
    end

    RateCls1(p,r) = (sum(Ytest == Yp01)/Ntest) * 100;
    RateCls2(p,r) = (sum(Ytest == Yp02)/Ntest) * 100;
    RateCls3(p,r) = (sum(Ytest == Yp03)/Ntest) * 100;
    RateCls4(p,r) = (sum(Ytest == Yp04)/Ntest) * 100;
    
    if(p == 6)
        if RateCls1(p,r) <= wRate1
            wRate1 = RateCls1(p,r); wCM1 = cfm(Ytest, Yp01, 3);
        end
    
        if RateCls1(p,r) >= bRate1
            bRate1 = RateCls1(p,r); bCM1 = cfm(Ytest, Yp01, 3);
        end
    
        if RateCls2(p,r) <= wRate2
            wRate2 = RateCls2(p,r); wCM2 = cfm(Ytest, Yp02, 3);
        end
    
        if RateCls2(p,r) >= bRate2
            bRate2 = RateCls2(p,r); bCM2 = cfm(Ytest, Yp02, 3);
        end
    
        if RateCls3(p,r) <= wRate3
            wRate3 = RateCls3(p,r); wCM3 = cfm(Ytest, Yp03, 3);
        end
    
        if RateCls3(p,r) >= bRate3
            bRate3 = RateCls3(p,r); bCM3 = cfm(Ytest, Yp03, 3);
        end
    
        if RateCls4(p,r) <= wRate4
            wRate4 = RateCls4(p,r); wCM4 = cfm(Ytest, Yp04, 3);
        end
    
        if RateCls4(r) >= bRate4
            bRate4 = RateCls4(r); bCM4 = cfm(Ytest, Yp04, 3);
        end
    end
    
end

    if P(p) == 0.8

        fprintf('Taxa Média de Acerto - Classificador 1: %.2f\n', mean(RateCls1(p,:)));
        fprintf('Taxa Média de Acerto - Classificador 2: %.2f\n', mean(RateCls2(p,:)));
        fprintf('Taxa Média de Acerto - Classificador 3: %.2f\n', mean(RateCls3(p,:)));
        fprintf('Taxa Média de Acerto - Classificador 4: %.2f\n', mean(RateCls4(p,:)));

        fprintf('Taxa Mínima de Acerto - Classificador 1: %.2f\n', min(RateCls1(p,:)));
        fprintf('Taxa Mínima de Acerto - Classificador 2: %.2f\n', min(RateCls2(p,:)));
        fprintf('Taxa Mínima de Acerto - Classificador 3: %.2f\n', min(RateCls3(p,:)));
        fprintf('Taxa Mínima de Acerto - Classificador 4: %.2f\n', min(RateCls4(p,:)));

        fprintf('Taxa Máxima de Acerto - Classificador 1: %.2f\n', max(RateCls1(p,:)));
        fprintf('Taxa Máxima de Acerto - Classificador 2: %.2f\n', max(RateCls2(p,:)));
        fprintf('Taxa Máxima de Acerto - Classificador 3: %.2f\n', max(RateCls3(p,:)));
        fprintf('Taxa Máxima de Acerto - Classificador 4: %.2f\n', max(RateCls4(p,:)));

        fprintf('Mediana da Taxa de Acerto - Classificador 1: %.2f\n', median(RateCls1(p,:)));
        fprintf('Mediana da Taxa de Acerto - Classificador 2: %.2f\n', median(RateCls2(p,:)));
        fprintf('Mediana da Taxa de Acerto - Classificador 3: %.2f\n', median(RateCls3(p,:)));
        fprintf('Mediana da Taxa de Acerto - Classificador 4: %.2f\n', median(RateCls4(p,:)));

        fprintf('Desvio Padrão da Taxa de Acerto - Classificador 1: %.2f\n', std(RateCls1(p,:)));
        fprintf('Desvio Padrão da Taxa de Acerto - Classificador 2: %.2f\n', std(RateCls2(p,:)));
        fprintf('Desvio Padrão da Taxa de Acerto - Classificador 3: %.2f\n', std(RateCls3(p,:)));
        fprintf('Desvio Padrão da Taxa de Acerto - Classificador 4: %.2f\n', std(RateCls4(p,:)));        
    end
end

figure; hold on;
subplot(2,2,1); boxplot(RateCls1',P*100);
ylim([45 100])
xlabel('Porcentagem dos dados de treinamento');
ylabel('Taxa de acerto');
title('Caso 1: \Sigma = I')

subplot(2,2,2); boxplot(RateCls2',P*100);
ylim([45 100])
xlabel('Porcentagem dos dados de treinamento');
ylabel('Taxa de acerto');
title('Caso 2: \Sigma = \Sigma_{pooled}');

subplot(2,2,3); boxplot(RateCls3',P*100);
ylim([0 100])
xlabel('Porcentagem dos dados de treinamento');
ylabel('Taxa de acerto');
title('Caso 3: \Sigma = \Sigma_{i}')

subplot(2,2,4); boxplot(RateCls4',P*100);
ylim([45 100])
xlabel('Porcentagem dos dados de treinamento');
ylabel('Taxa de acerto');
title('Caso 4: \Sigma = diag(\sigma^{2}_{1},\sigma^{2}_{2},...\sigma^{2}_{p})');

figure;
subplot(2,2,1); hold on;
title('Evolução das Taxas Média, Mínima e Máxima de Acerto - Classificador 1');
plot(P*100, mean(RateCls1,2));
plot(P*100, min(RateCls1,[],2));
plot(P*100, max(RateCls1,[],2));
xlabel('Porcentagem de dados de treinamento');

subplot(2,2,2); hold on;
title('Evolução das Taxas Média, Mínima e Máxima de Acerto - Classificador 2');
plot(P*100, mean(RateCls2,2));
plot(P*100, min(RateCls2,[],2));
plot(P*100, max(RateCls2,[],2));
xlabel('Porcentagem de dados de treinamento');

subplot(2,2,3); hold on;
title('Evolução das Taxas Média, Mínima e Máxima de Acerto - Classificador 3');
plot(P*100, mean(RateCls3,2));
plot(P*100, min(RateCls3,[],2));
plot(P*100, max(RateCls3,[],2));
xlabel('Porcentagem de dados de treinamento');

subplot(2,2,4); hold on;
title('Evolução das Taxas Média, Mínima e Máxima de Acerto - Classificador 4');
plot(P*100, mean(RateCls4,2));
plot(P*100, min(RateCls4,[],2));
plot(P*100, max(RateCls4,[],2));
xlabel('Porcentagem de dados de treinamento');

% legend1 = legend('Taxa de acerto média', ...
%                  'Taxa de acerto mínima', ...
%                  'Taxa de acerto máxima');
% set(legend1,'Location','northwest');

