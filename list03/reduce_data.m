function [Xtrain, Ytrain, Xtest, Ytest] = reduce_data(data, Ni, Niu, p)
    X = data(:,1:6); X = X';
    vars = diag(cov(X'));
    [nvars, w] = sort(vars,'descend');
    X = X(w(1:4),:);   
        
    Y = data(:,Ni+1); Y = Y';
    
    N = size(X,2);

    Ytrain = [];
    
    while (sum(Ytrain == 1) == 0 || sum(Ytrain == 2) == 0 || sum(Ytrain == 1) == 0)
        Irand = randperm(N);
        X = X(:,Irand);
        Y = Y(:,Irand);

        cut = floor(p * N);
        Xtrain = X(:,1:cut); Xtest = X(:,cut+1:end);
        Ytrain = Y(:,1:cut); Ytest = Y(:,cut+1:end);    
    end

end


    % for i = 1:6
    %     m = mean(X(i,:));
    %     s = std(X(i,:));
    %     X(i,:) = (X(i,:) - m)/s;
    % end