function [W I] = kmeans_sequential(Wo,X,K,R)

    W = Wo;
    N = size(X,2);
    Cw = zeros(1,K);
    
    bestW = [];
    SSD = intmax;

    for r = 1:R
        for t = 1:N            
            w = kmeans_labels(X(:,t),W);
            Cw(w) = Cw(w) + 1;            
            W(:,w) = W(:,w) +  (1/Cw(w)) * (X(:,t) - W(:,w));
        end
        
        newSSD = kmeans_ssd(X,W,K);
        if newSSD < SSD
            SSD = newSSD;
            bestW = W;
        end
        
        W = kmeans_start_prototypes(X,K);
    end
    
    W = bestW;
    I = kmeans_labels(X,W);
end