function testlib(LIB,flag,varargin)
% flag: either All, current, last, or version number
% LIB: e.g. WTlib, BEM, VC_LIB_C or an empty string to look in current directory
% varargin: passed to fRunTest, if the user wants to run a specific test

% for librairies that don't have subversions, use runtests directly
global DEBUG
global PLOT
global STOP
STOP=0;
PLOT=0;
DEBUG=0;


setDefaultPath
global PATH
if(~isempty(LIB))
    vers=dir([getfield(PATH,LIB) 'v*']);
    folder=getfield(PATH,LIB); 
else
    vers=dir('v*');
    folder='./';
end

warning off;
if(isequal(flag,'all') || isequal(flag,'All'))
    for iv =1:length(vers)
        fRunTest(vers(iv).name,folder,varargin);
    end
else
    if(isequal(flag,'current') || isequal(flag,'last'))
        vnum=zeros(1,length(vers));
        for iv =1:length(vers)
            vnum(iv) =str2num(vers(iv).name(2:3));
        end
        [s I]=sort(vnum);
        fRunTest(vers(I(end)).name,folder,varargin);
    else
        %the use has provided a version number
        fRunTest(flag,folder,varargin);
    end
end

clearPath;
% runtests(varargin) ; % the original one
warning on;

function fRunTest(name,folder,test)
global VERSION
global VERSIONNUM
VERSION=name;
if(iscell(name))
    name=cell2mat(VERSION);
    VERSIONNUM=cellfun(@(x) str2num(x(2:3)),VERSION);
    if(length(VERSION)==1)
        VERSION=VERSION{1};
    end
else
    VERSIONNUM=str2num(VERSION(2:3));
end
folder=[folder '__tests__/'];
oldfold=pwd;
if(~isempty(test))
    cd(folder);
    % the usr want a specific test
    folder=[test{1}];
end
fprintf('----------------------------------------------------------------------------------------------\n');
fprintf('----------------------------------------------------------------------------------------------\n');
fprintf('----------------------------------------------------------------------------------------------\n');
fprintf('------------ TESTS ----  VERSION:  %s   -  FOLDER: %s\n',name,folder);
fprintf('----------------------------------------------------------------------------------------------\n');
fprintf('----------------------------------------------------------------------------------------------\n');
fprintf('----------------------------------------------------------------------------------------------\n');
runtests(folder); % using xunit matlab central library
cd(oldfold);
