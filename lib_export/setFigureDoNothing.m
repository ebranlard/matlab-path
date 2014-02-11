function setFigureDoNothin(bDo)
    global bFigureDoNothing;
    if bDo~=0 && bDo~=1
        error('Argument should be a boolean')
    end
    bFigureDoNothing=bDo;
end
