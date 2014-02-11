function setFigureFont(font)
    global FigureFont;
    if ~isstr(font)
        error('Argument should be a string: "default" or a font size value e.g. "14" ')
    end
    if isempty(font) || isequal(font,'') || isequal(font,'default')
        FigureFont='default';
    else
        FigureFont=font;
    end
end
