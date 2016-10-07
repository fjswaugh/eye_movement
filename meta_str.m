function str = meta_str(meta)
%meta_str Generates a string that displays meta data in human readable way

    str = ['flank: ', lower(meta.flank),...
           ', colour: ', lower(meta.color),...
           ', luminance: ', meta.luminance];
end