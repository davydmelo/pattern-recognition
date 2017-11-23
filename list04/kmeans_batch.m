function [W,I] = kmeans_batch(Wo,X,K,R)
    W = Wo;
    N = size(X,2);
    
    bestW = [];
    SSD = intmax;

    for r = 1:R
        I = kmeans_labels(X,W);
        for w = 1:K
            W(:,w) = sum(X(:,find(I == w)),2)/length(find(I == w));
        end
        
        newSSD = kmeans_ssd(X,W,K);
        if newSSD < SSD
            SSD = newSSD;
            bestW = W;
        end
    end
    
    W = bestW;    
    I = kmeans_labels(X,W);
end

