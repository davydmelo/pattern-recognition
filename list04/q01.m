warning('on','all')
clear, clc, close all;
format short g;

K = [2, 3, 4, 5, 6, 7];
DI = zeros(1,length(K)); CH = zeros(1,length(K));
DIs = zeros(1,length(K)); CHs = zeros(1,length(K));
R = 100;

%data = load('../datasets/vertebral_column/column_3C.dat');

data = load('../datasets/three-balls/threeballs.mat');
data = data.data';

X = data(:,1:2); X = X';
N = size(X,2);

% Normalização dos dados
X = (X - repmat(mean(X,2),1,N)) ./ repmat(std(X,[],2),1,N);
X = X(:,randperm(N));

for k = 1:length(K)
    
    [Wb, Ws] = kmeans_start_prototypes(X,K(k));
    
    [Wb, Ib] = kmeans_batch(Wb,X,K(k),R);
    DI(k) = kmeans_dunn_index(Wb,X,Ib,K(k));
    CH(k) = kmeans_calinski_harabasz(Wb,X,Ib,K(k));
    
    [Ws Is] = kmeans_sequential(Ws,X,K(k),R);
    DIs(k) = kmeans_dunn_index(Ws,X,Is,K(k));
    CHs(k) = kmeans_calinski_harabasz(Ws,X,Is,K(k));
    
    if K(k) == 3
        plot(X(1,:),X(2,:),'ro', Wb(1,:),Wb(2,:),'ko', Ws(1,:),Ws(2,:),'b*'); figure;
    end

end

plot(K,DI); figure;
plot(K,CH); figure;
plot(K,DIs); figure;
plot(K,CHs);


