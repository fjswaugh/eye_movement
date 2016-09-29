function [result] = pearson(A, B)
    C = cov(A, B);
    result = C(2) / (std(A) * std(B));
end
