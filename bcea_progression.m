% Gives a list of how the bcea progresses through the time of the recording
function bceas = bcea_progression(x, y, k)
    bceas = zeros(length(x), 1);
    for t = 1:length(x)
        bceas(t) = bcea(x(1:t), y(1:t), k);
    end
end
