function [W, Wr] = kmeans_start_prototypes(X,K)
    
    N = size(X,2);
    Iw = randi([1 N],1,K);
    W = X(:,Iw);
    Wr = W;
    
end

