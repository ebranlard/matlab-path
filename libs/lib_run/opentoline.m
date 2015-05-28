function opentoline(file, line, column)
%OPENTOLINE Open to specified line in function file in Emacs.
%   This is a hack to override the built-in opentoline program in MATLAB.
%
%   Remove this M file from your path to get the old behavior.

    editor = system_dependent('getpref', 'EditorOtherEditor');
    editor = editor(2:end);
    
if isempty(editor)
    opentoline_legacy(file, line, column)
else
    if nargin==3
        linecol = sprintf('+%d:%d',line,column);
        linecol = sprintf('+%d',line); % tehre is something about -c "normal column|" but it didn't work
    else
        linecol = sprintf('+%d',line);
    end
    
    if ispc
        % On Windows, we need to wrap the editor command in double quotes
        % in case it contains spaces
        system(['"' editor '" "' linecol '" "' file '"&']);
    else
        % On UNIX, we don't want to use quotes in case the user's editor
        % command contains arguments (like "xterm -e vi")
        system([editor ' "' linecol '" "' file '" &']);
    end
end

function opentoline_legacy(fileName, lineNumber, columnNumber)
%% complete the path if it is not absolute
javaFile = java.io.File(fileName);
if ~javaFile.isAbsolute
    %resolve the filename if a partial path is provided.
    fileName = char(com.mathworks.util.FileUtils.absolutePathname(fileName));
end
lineNumber = abs(lineNumber); % dbstack uses negative numbers for "after"

%% open the editor
if exist(fileName,'file')
    %open open the editor if the file exists, otherwise, a dialog will be shown.
    if nargin == 2
        %just go to a particular line
        editorservices.openAndGoToLine(fileName, lineNumber);
    else
        %go to a line and a column
        editorObj = editorservices.open(fileName);
        editorObj.goToLineAndColumn(lineNumber, columnNumber);
    end
end
