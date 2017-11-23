function [SSD] = kmeans_ssd(X,W,K)

    SSD = 0;    
    I = kmeans_labels(X,W);
    
    for i = 1:K
        Vi = X(:,find(I == i));
        P = 0;
        
        for j = 1:size(Vi,2)
            P = P + (Vi(:,j) - W(:,i))'*(Vi(:,j) - W(:,i));
        end
        
        SSD = SSD + P;
    end

end

