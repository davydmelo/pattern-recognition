function [I] = kmeans_labels(X,W)
    N = size(X,2);
    I = zeros(1,N);

    D = dist(W',X);        
    MinD = min(D);
    
    for n = 1:N
        minIndexes = find(D(:,n) == MinD(n));
        I(n) = minIndexes(1);            
    end

end

