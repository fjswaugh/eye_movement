function [found] = str_contains(string, search_text)
    found = not(isempty(strfind(string, search_text)));
end
