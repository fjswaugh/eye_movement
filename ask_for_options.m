function [print_options] = ask_for_options()
% Function asks user for various options about how to present the results
    print_options = struct('graph'            , false,...
                           'hist'             , false,...
                           'progression_graph', false,...
                           'gif'              , false);

    question = 'Print graphs (there will be two for each trial)?'; 
    print_options.graph = ask_y_or_n(question);

    question = 'Print histograms of eye movement (time consuming)?';
    print_options.hist = ask_y_or_n(question);
    
    question = 'Print progression graphs?';
    print_options.progression_graph = ask_y_or_n(question);

    question = 'Print animated gif of eye movement (time consuming)?';
    print_options.gif = ask_y_or_n(question);
end

function [answer] = ask_y_or_n(question)
    y_or_n = '';
    while not(or(strcmp(y_or_n, 'y'), strcmp(y_or_n, 'n')))
        y_or_n = input([question, ' [y/n] '], 's');
    end
    answer = (y_or_n == 'y');
end

