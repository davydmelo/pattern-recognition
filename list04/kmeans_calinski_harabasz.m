function [CH] = kmeans_calinski_harabasz(W,X,I,K)
    
    N = size(X,2);
    xb = mean(X,2);
    
    Bk = zeros(size(X,1),size(X,1));
    Wk = zeros(size(X,1),size(X,1));
    
    for k = 1:K
        V{k} = X(:,find(I == k));
    end

    for i = 1:K
        Bk = Bk + sum(I == i) * (W(:,i) - xb) * (W(:,i) - xb)'; 
    end
    
    for i = 1:K
        Vi = V{i};
        Pk = zeros(size(X,1),size(X,1));
        for j = 1:size(Vi,2)
            Pk = Pk + (Vi(:,j) - W(:,i)) * (Vi(:,j) - W(:,i))'; 
        end
        Wk = Wk + Pk;
    end
    
    CH = (trace(Bk)/(K - 1))/(trace(Wk)/(N - K));

end

