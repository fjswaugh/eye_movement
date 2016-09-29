function [] = print_trial(data, print_options)
    if print_options.graph
        print_position_graphs(data);
    end
    
    if print_options.hist
        print_histogram(data);
    end
        
    if print_options.progression_graph
        print_bcea_progression(data, true);
    end

    if print_options.gif
        print_gif(data);
    end
end
