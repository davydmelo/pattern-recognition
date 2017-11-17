function [Conf] = cfm(Ytest, Ypred, Nc)
    Conf = zeros(Nc, Nc);
    
    for r = 1:Nc
        I = find(Ytest == r);
        for c = 1:Nc
            Conf(r,c) = sum(Ypred(I) == c) / length(I);
        end
    end
end

