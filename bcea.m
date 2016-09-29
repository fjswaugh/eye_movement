function bcea = bcea(x, y, k)
    bcea = 2*k*pi * std(x) * std(y) * (1 - pearson(x, y)^2)^0.5;
end
