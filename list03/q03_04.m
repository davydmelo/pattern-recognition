warning('on','all')
clear, clc, close all;
format short g;

R = 100;
data = load('../datasets/vertebral_column/column_3C.dat');

RateCls = zeros(1,R);
RateClsP = zeros(1,R);
RateClsR = zeros(1,R);
q = 4;

for r = 1:R
    [Xtrain, Ytrain, Xtest, Ytest] = part_data(data, 6, 6, 0.8);
    Ntrain = size(Xtrain,2);
    Ntest = size(Xtest,2);
    
    [XtrainR, YtrainR, XtestR, YtestR] = reduce_data(data, 6, 4, 0.8);
    NtrainR = size(XtrainR,2);
    NtestR = size(XtestR,2);

    I1 = find(Ytrain == 1); I2 = find(Ytrain == 2); I3 = find(Ytrain == 3);
    n1 = length(I1); n2 = length(I2); n3 = length(I3);
    X1 = Xtrain(:,I1); X2 = Xtrain(:,I2); X3 = Xtrain(:,I3);
    m1 = sum(X1,2)/n1; m2 = sum(X2,2)/n2; m3 = sum(X3,2)/n3;
    Cx1 = cov(X1'); Cx2 = cov(X2'); Cx3 = cov(X3');
    p1 = n1/Ntrain; p2 = n2/Ntrain; p3 = n3/Ntrain;
    CxP = p1 * Cx1 + p2 * Cx2 + p3 * Cx3;
    invCxP = inv(CxP);
    
    I1r = find(YtrainR == 1); I2r = find(YtrainR == 2); I3r = find(YtrainR == 3);
    n1r = length(I1r); n2r = length(I2r); n3r = length(I3r);
    X1r = XtrainR(:,I1r); X2r = XtrainR(:,I2r); X3r = XtrainR(:,I3r);
    m1r = sum(X1r,2)/n1r; m2r = sum(X2r,2)/n2r; m3r = sum(X3r,2)/n3r;
    Cx1r = cov(X1r'); Cx2r = cov(X2r'); Cx3r = cov(X3r');
    p1r = n1r/NtrainR; p2r = n2r/NtrainR; p3r = n3r/NtrainR;
    CxPr = p1r * Cx1r + p2r * Cx2r + p3r * Cx3r;
    invCxPr = inv(CxPr);
        
%     [V1 L1] = eig(Cx1);
%     L1 = diag(L1);
%     [L1 I1] = sort(L1,'descend');
%     V1 = V1(:,I1);
%     Q1 = V1(:,1:q)';
%     
%     [V2 L2] = eig(Cx2);
%     L2 = diag(L2);
%     [L2 I2] = sort(L2,'descend');
%     V2 = V2(:,I2);
%     Q2 = V2(:,1:q)';
%     
%     [V3 L3] = eig(Cx3);
%     L3 = diag(L3);
%     [L3 I3] = sort(L3,'descend');
%     V3 = V3(:,I3);
%     Q3 = V3(:,1:q)';
%     
%     m1t = Q1 * m1;
%     m2t = Q2 * m2;
%     m3t = Q3 * m3;
%     
%     X1t = Q1 * X1;
%     X2t = Q2 * X2;
%     X3t = Q3 * X3;

    [V L] = eig(CxP);
    L = diag(L);
    [L I] = sort(L,'descend');
    V = V(:,I);
    Q = V(:,1:q)';
    
    m1t = Q * m1;
    m2t = Q * m2;
    m3t = Q * m3;
    
    X1t = Q * X1;
    X2t = Q * X2;
    X3t = Q * X3;
    
    CxPt = (n1/Ntrain) * cov(X1t') + (n2/Ntrain) * cov(X2t') + (n3/Ntrain) * cov(X3t'); invCxPt = inv(CxPt);
%     Cx1t = cov(X1t'); Cx2t = cov(X2t'); Cx3t = cov(X3t');
  
    Yn = zeros(1,Ntest);
    Yp = zeros(1,Ntest);
    Yr = zeros(1,Ntest);

    for i = 1:Ntest
        xn = Xtest(:,i);
        xnt = Q * xn;
        xnr = XtestR(:,i);
        %xnt = ((Q1+Q2+Q3)/3) * xn;
          
%         g1 = -(1/2) * (xn - m1)' * inv(Cx1 + eye(size(Cx1)) * 0.000001) * (xn - m1) - (1/2) * log(det(Cx1)) + log(p1);
%         g2 = -(1/2) * (xn - m2)' * inv(Cx2 + eye(size(Cx2)) * 0.000001) * (xn - m2) - (1/2) * log(det(Cx2)) + log(p2);
%         g3 = -(1/2) * (xn - m3)' * inv(Cx3 + eye(size(Cx3)) * 0.000001) * (xn - m3) - (1/2) * log(det(Cx3)) + log(p3);
%         
%         g1p = -(1/2) * (xnt - m1t)' * inv(Cx1t + eye(size(Cx1t)) * 0.000001) * (xnt - m1t) - (1/2) * log(det(Cx1t)) + log(p1);
%         g2p = -(1/2) * (xnt - m2t)' * inv(Cx2t + eye(size(Cx2t)) * 0.000001) * (xnt - m2t) - (1/2) * log(det(Cx2t)) + log(p2);
%         g3p = -(1/2) * (xnt - m3t)' * inv(Cx3t + eye(size(Cx3t)) * 0.000001) * (xnt - m3t) - (1/2) * log(det(Cx3t)) + log(p3);

        g1 = -(1/2) * (xn - m1)' * invCxP * (xn - m1);
        g2 = -(1/2) * (xn - m2)' * invCxP * (xn - m2);
        g3 = -(1/2) * (xn - m3)' * invCxP * (xn - m3);

        g1p = -(1/2) * (xnt - m1t)' * invCxPt * (xnt - m1t);
        g2p = -(1/2) * (xnt - m2t)' * invCxPt * (xnt - m2t);
        g3p = -(1/2) * (xnt - m3t)' * invCxPt * (xnt - m3t);
        
        g1r = -(1/2) * (xnr - m1r)' * invCxPr * (xnr - m1r);
        g2r = -(1/2) * (xnr - m2r)' * invCxPr * (xnr - m2r);
        g3r = -(1/2) * (xnr - m3r)' * invCxPr * (xnr - m3r);

        Yn(i) = find([g1; g2; g3] == max([g1; g2; g3]));
        Yp(i) = find([g1p; g2p; g3p] == max([g1p; g2p; g3p]));
        Yr(i) = find([g1r; g2r; g3r] == max([g1r; g2r; g3r]));
   end

    RateCls(r) = (sum(Ytest == Yn)/Ntest) * 100;
    RateClsP(r) = (sum(Ytest == Yp)/Ntest) * 100;
    RateClsR(r) = (sum(YtestR == Yr)/NtestR) * 100;
end
        
fprintf('Taxa Média de Acerto - Classificador 3 sem PCA: %.2f\n', mean(RateCls));
fprintf('Taxa Média de Acerto - Classificador 3 com PCA: %.2f\n', mean(RateClsP));
fprintf('Taxa Média de Acerto - Classificador 3 com Redução: %.2f\n', mean(RateClsR));

fprintf('Taxa Mínima de Acerto - Classificador 3 sem PCA: %.2f\n', min(RateCls));
fprintf('Taxa Mínima de Acerto - Classificador 3 com PCA: %.2f\n', min(RateClsP));
fprintf('Taxa Mínima de Acerto - Classificador 3 com Redução: %.2f\n', min(RateClsR));
        
fprintf('Taxa Máxima de Acerto - Classificador 3 sem PCA: %.2f\n', max(RateCls));
fprintf('Taxa Máxima de Acerto - Classificador 3 com PCA: %.2f\n', max(RateClsP));
fprintf('Taxa Máxima de Acerto - Classificador 3 com Redução: %.2f\n', max(RateClsR));

fprintf('Mediana da Taxa de Acerto - Classificador 3 sem PCA: %.2f\n', median(RateCls));
fprintf('Mediana da Taxa de Acerto - Classificador 3 com PCA: %.2f\n', median(RateClsP));
fprintf('Mediana da Taxa de Acerto - Classificador 3 com Redução: %.2f\n', median(RateClsR));

fprintf('Desvio Padrão da Taxa de Acerto - Classificador 3 sem PCA: %.2f\n', std(RateCls));
fprintf('Desvio Padrão da Taxa de Acerto - Classificador 3 com PCA: %.2f\n', std(RateClsP));        
fprintf('Desvio Padrão da Taxa de Acerto - Classificador 3 com Redução: %.2f\n', std(RateClsR));      
    
figure; hold on;
subplot(1,3,1); boxplot(RateCls);
%ylim([70 100])
xlabel('Porcentagem dos dados de treinamento');
ylabel('Taxa de acerto');
title('Classificador 3 sem PCA')

subplot(1,3,2); boxplot(RateClsP);
%ylim([70 100])
xlabel('Porcentagem dos dados de treinamento');
ylabel('Taxa de acerto');
title('Classificador 3 com PCA')

subplot(1,3,3); boxplot(RateClsR);
%ylim([70 100])
xlabel('Porcentagem dos dados de treinamento');
ylabel('Taxa de acerto');
title('Classificador 3 com Redução')