function [DI] = kmeans_dunn_index(W,X,I,K)
    separations = [];
    cohesions = [];
    
    for k = 1:K
        V{k} = X(:,find(I == k));
    end
    
    for i = 1:K
        Vi = V{i};
        for j = 1:K
            if i == j
                continue
            end
            
            Vj = V{j};
            D = dist(Vi',Vj);
            separations = [separations min(min(D))];            
        end
    end
    
    for i = 1:K
        Vi = V{i};
        cohesions = [cohesions max(max(dist(Vi',Vi)))];
    end

    separation = min(separations);
    internal_cohesion = max(cohesions);
    
    DI = separation/internal_cohesion;
end

