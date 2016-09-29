% Gives a list of how the bcea progresses through the time of the recording
function bceas = bcea_progression(x, y, k)
    bceas = zeros(size(x, 1), 1);
    for t = 1:size(x, 1)
        bceas(t) = bcea(x(1:t), y(1:t), k);
    end
end
