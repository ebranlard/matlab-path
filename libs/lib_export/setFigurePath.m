function setFigurePath(path)
	global FigurePath;
	FigurePath=path;
    %% Just in case InitClear is not used, 
    global SCRIPT
    if ~isfield(SCRIPT,'name')
        SCRIPT.run_date=datestr(now);
        SCRIPT.run_dir=pwd();
        stk=dbstack();
        stack_length=length(stk);
        if stack_length>=2
            [~,SCRIPT.name]=fileparts(stk(2).file);
        end
    end
end
