function str = data_type_str(type)
    if type == -3
        str = 'Correct catch';
    elseif type == -2
        str = 'Correct reversal';
    elseif type == -1
        str = 'Correct';
    elseif type == 1
        str = 'Incorrect';
    elseif type == 2
        str = 'Incorrect reversal';
    elseif type == 3
        str = 'Incorrect catch';
    else
        str = '';
    end
end