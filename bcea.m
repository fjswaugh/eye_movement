function bcea = bcea(x, y, k)
% BCEA  Calculate the B.C.E.A. of a data set.
%   b = BCEA(x, y, k) calculates B.C.E.A. given x and y position data for
%   some linear value of k.
    bcea = 2*k*pi * std(x) * std(y) * (1 - pearson(x, y)^2)^0.5;
end
