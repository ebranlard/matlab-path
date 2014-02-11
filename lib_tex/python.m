function [result status] = Python(varargin)
%Python Execute Python command and return the result.
%   Python(PythonFILE) calls Python script specified by the file PythonFILE
%   using appropriate Python executable.
%
%   Python(PythonFILE,ARG1,ARG2,...) passes the arguments ARG1,ARG2,...
%   to the Python script file PythonFILE, and calls it by using appropriate
%   Python executable.
%
%   RESULT=Python(...) outputs the result of attempted Python call.  If the
%   exit status of Python is not zero, an error will be returned.
%
%   [RESULT,STATUS] = Python(...) outputs the result of the Python call, and
%   also saves its exit status into variable STATUS. 
% 
%   If the Python executable is not available, it can be downloaded from:
%     http://www.cpan.org
%
%   See also SYSTEM, JAVA, MEX.

%   Copyright 1990-2007 The MathWorks, Inc.
%   $Revision: 1.1.4.8 $

cmdString = '';

% Add input to arguments to operating system command to be executed.
% (If an argument refers to a file on the MATLAB path, use full file path.)
for i = 1:nargin
    thisArg = varargin{i};
    if isempty(thisArg) || ~ischar(thisArg)
        error('MATLAB:Python:InputsMustBeStrings', 'All input arguments must be valid strings.');
    end
    if i==1
        if exist(thisArg, 'file')==2
            % This is a valid file on the MATLAB path
            if isempty(dir(thisArg))
                % Not complete file specification
                % - file is not in current directory
                % - OR filename specified without extension
                % ==> get full file path
                thisArg = which(thisArg);
            end
        else
            % First input argument is PythonFile - it must be a valid file
            error('MATLAB:Python:FileNotFound', 'Unable to find Python file: %s', thisArg);
        end
    end
  
  % Wrap thisArg in double quotes if it contains spaces
  if any(thisArg == ' ')
    thisArg = ['"', thisArg, '"'];
  end
  
  % Add argument to command string
  cmdString = [cmdString, ' ', thisArg];
end

% Execute Python script
errTxtNoPython = 'Unable to find Python executable.';

if isempty(cmdString)
  error('MATLAB:Python:NoPythonCommand', 'No Python command specified');
elseif ispc
  % PC
%  PythonCmd = fullfile(matlabroot, 'sys\Python\win32\bin\');
  PythonCmd = fullfile('C:/bin/Python27/');
  cmdString = ['python.exe' cmdString];	 
  PythonCmd = ['set PATH=',PythonCmd, ';%PATH%&' cmdString];
  [status, result] = dos(PythonCmd);
else
  % UNIX
  [status ignore] = unix('which python'); %#ok
  if (status == 0)
    cmdString = ['python', cmdString];
    [status, result] = unix(cmdString);
else
  [status ignore] = unix('which Python'); %#ok
  if (status == 0)
      cmdString = ['Python', cmdString];
      [status, result] = unix(cmdString);
  else 
    error('MATLAB:Python:NoExecutable', errTxtNoPython);
  end
  end
end

% Check for errors in shell command
if nargout < 2 && status~=0
  error('MATLAB:Python:ExecutionError', ...
        'System error: %sCommand executed: %s', result, cmdString);
end

