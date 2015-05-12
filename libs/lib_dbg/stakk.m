function stakkname = stakk(varargin)
% STAKK stores and compares workspaces of functions in runtime.
% STAKK is a function that helps debugging of data and programs. During
% development, there are often several versions of functions used in
% the main program and direct comparison of the functions' workspace
% is not easily possible between different program runs or at different 
% points in runtime. STAKK stores all or selected variables of the current 
% workspace in a struct in the base workspace for later retrieval and/or 
% comparison. It is possible to select variables by providing one 
% regular expression string (Matlab 7.0 or later).
% 
% You use STAKK by putting STAKK('pushall', ...) or STAKK('push', ...)
% into the code of functions you want to store the workspace at that time. 
% Later, in KEYBOARD/Debug mode or after the program exits you will find 
% the saved workspace in the base workspace as a structs with the default
% names 's1', 's2',... You may then invoke STAKK('compare', 's1', 's2')
% to quickly check whether s1 and s2 contain the same data in the same
% fields and which differences are found where. Note that this version 
% only checks equality in a limited, non-recursive way.
%
% Invoke STAKK with the following syntax: 
% 
% STAKK;            The same as STAKK('pushall');    
%
% STAKK('pushall'); Stores the whole workspace in a storage struct in base. 
%                   The default name of the storage struct is formed by
%                   concatenating the <storeprefix> string (currently 
%                   's') with a number, i.e. 's1'. If 's1' already exists,
%                   a unique name is created by appending increasing
%                   numbers ('s2','s3',...).
%
% STAKK('pushall', lagername); Stores the whole workspace in <lagername>.
%                   If <lagername> already exists, a unique name is created
%                   by appending increasing numbers.
%
% STAKK('push', regexp); Stores variables with names that fulfill a regular
%                   expression condition. Note that in contrast to 
%                   'whos('-regexp',...)' you may only give one regexp 
%                   string (but you are allowed to use the pipe '|'). This
%                   functionality works in Matlab 7.0 and later; see 
%                   'help regexp' for descriptions.
%
% STAKK('push', regexp, lagername); Stores variables with names that
%                   fulfill a regular expression condition in <lagername>.
%                   If <lagername> already exists, a unique name is created
%                   by appending increasing numbers. This functionality
%                   works in Matlab 7.0 and later.
%
% STAKK('compare', 'lager1', 'lager2'); Compares two previously stored 
%                   structs. A report is printed onto Matlab's command
%                   window. 
%
% STAKK('includeGlobals'); Include globals in subsequent calls of stakk.
%                   This is the default behavior.
% 
% STAKK('excludeGlobals'); Exclude globals in subsequent calls of stakk.
%
%
% The name of the storage struct is returned as a string (exception: 
% STAKK('includeGlobals') and STAKK('excludeGlobals') do not return any 
% objects). It is therefore allowed to use i.e. 
% STAKK('compare', 's1', stakk()); to compare s1 with the actual workspace. 
%
% see 'edit stakk' for further details.

% More Info:
%
% - Variables that are declared as 'global' in the caller's workspace
% are included by default, but can be excluded. Note that only those
% global variables are included which are declared as 'global' within
% the caller, not all global variables.
%
% - This version checks equality by using MatLab's ISEQUALWITHEQUALNANS,
% which works also for structs and cell arrays. In a next version, the
% structs and cells will be recursively checked and differences listed.
% 
% - Note that if STAKK's calling workspace is 'base', consecutive calls of
% STAKK contain all the previously stored structs as well (i.e. the first
% storage struct s1 will be in s2, and s1 and s2 will be in s3 etc...).
% You can remove them manually before invoking STAKK('compare',...) by
% using MatLab's function 'rmfield'; ie.: 's2 = rmfield(s2,'s1')', to 
% remove the storage struct s1 from s2.
% 
% - If you want to change the default name of the storage structs, you
% may manually change the persistent variable 'storeprefix' below. 
%
%
% Version 1.0.3, 09.03.05, made by 
% Fabio Wegmann with help from Laurent Cavin
%
% Please send bugs, feature requests etc. to fabio.wegmann (at) 
% ethz.ch
% You may also contact me if you want to be notified about new releases
% of STAKK.
% 
% 
% ideas for future improvements: 
% - recursive struct parsing and content comparison
%

persistent showGlobals storeprefix storenum;

storeprefix = 's'; % standard name prefix for stored stakk in base

if nargin > 3
    error('stakk.m: maximal 3 inputs. See ''help stakk'' for more information.');
end
inputcell = varargin;
numinputs = nargin;
if nargin == 0      % if STAKK is invoked as 'STAKK'
    numinputs = 1;
    inputcell{1} = 'pushall';
end

if isempty(showGlobals)
    showGlobals = true; % default: show globals 
end

tmpstakk = [];
switch numinputs
    case 1
        % includeGlobals, excludeGlobals, pushall
        switch inputcell{1}
            case 'includeGlobals'
                showGlobals = true;
            case 'excludeGlobals'
                showGlobals = false;
            case 'pushall'
                % stores all variables into a struct 
                if isempty(storenum)
                   storenum = 0; % part of lager name
                end
                storenum = storenum + 1;
                stakkname = [storeprefix int2str(storenum)];
                
                % build two lists of local and global vars
                allvar = evalin('caller','whos');
                globvar = evalin('caller','whos(''global'')');
                
                setall = {allvar.name}; % names of all vars in caller
                setglob = {globvar.name}; % names of all global vars in caller
                setglob = intersect(setglob, setall); % take only globals
                % that are declared global in caller's workspace
                [ignore, locidx] = setdiff(setall, setglob);
                locvar = allvar(locidx); % list of all local variables in caller
                 
                % if globals should be included...
                if showGlobals
                    for i = 1:length(setglob)
                        tmpval = evalin('caller', setglob{1});
                        tmpstakk.(setglob{1}) = tmpval;
                    end
                end

                % store locals in tmpstakk
                for i = 1:length(locvar)
                    tmpval = evalin('caller', locvar(i).name);
                    tmpstakk.(locvar(i).name) = tmpval;
                end
                
                % create unique stakkname in base and store stakk in base
                while evalin('base',['exist(''' stakkname ''')'])
                    storenum = storenum + 1;
                    stakkname = [storeprefix int2str(storenum)];
                end
                
                assignin('base', stakkname, struct(tmpstakk));
                
                %MANU
                eval([stakkname,'=struct(tmpstakk);']);
                save([stakkname '_dump.mat'],stakkname);

            otherwise
                error(['stakk.m: unidentifiable 1-parameter usage. See ''help stakk'' for more information']);
        end

    case 2
        % pushall(lagername), push(regexp)
        switch inputcell{1}
            case 'pushall'
                % store all variables in <lagername> in base
                lagername = inputcell{2};
                if isempty(storenum)
                    storenum = 0; % part of lager name
                end
                
                % build two lists of local and global vars
                allvar = evalin('caller','whos');
                globvar = evalin('caller','whos(''global'')');
                
                setall = {allvar.name}; % names of all vars in caller
                setglob = {globvar.name}; % names of all global vars in caller
                setglob = intersect(setglob, setall); % take only globals
                % that are declared global in caller's workspace
                [ignore, locidx] = setdiff(setall, setglob);
                locvar = allvar(locidx); % list of all local variables in caller
                
                
                % if globals should be included...
                if showGlobals
                    for i = 1:length(setglob)
                        tmpval = evalin('caller', setglob{1});
                        tmpstakk.(setglob{1}) = tmpval;
                    end
                end

                % store locals in tmpstakk
                for i = 1:length(locvar)
                    tmpval = evalin('caller', locvar(i).name);
                    tmpstakk.(locvar(i).name) = tmpval;
                end
                
                % check if lagername in base is unique
                while evalin('base',['exist(''' lagername ''')'])
                    storenum = storenum + 1;
                    neulager = [lagername int2str(storenum)];
                    warning('stakk:NAME',...
                        'stakk.m: the lagername %s already exists in base! I try %s', ...
                        lagername, neulager);
                    lagername = neulager;
                end
                
                % store stakk in base under unique name lagername
                assignin('base', lagername, struct(tmpstakk));
                stakkname = lagername; % copy return value


            case 'push'
                % pushes regexp-selected variables only
                if isempty(storenum)
                   storenum = 0; % part of lager name
                end
                storenum = storenum + 1;
                stakkname = [storeprefix int2str(storenum)];
                regulexp = inputcell{2};
                
                ver = version; % check whether '-regexp' in 'whos' below works...
                if str2num(ver(1))<7
                    error('stakk.m: regular expression works in Matlab 7.0 and greater.');
                end

                
                % build two lists of local and global vars
                allvar = evalin('caller',['whos(''-regexp'', ''' regulexp ''')']);
                globvar = evalin('caller',['whos(''global'', ''-regexp'', ''' regulexp ''')']);
                
                setall = {allvar.name}; % names of all vars in caller
                setglob = {globvar.name}; % names of all global vars in caller
                setglob = intersect(setglob, setall); % take only globals
                % that are declared global in caller's workspace
                [ignore, locidx] = setdiff(setall, setglob);
                locvar = allvar(locidx); % list of all local variables in caller
                
                
                % if globals should be included...
                if showGlobals
                    for i = 1:length(setglob)
                        tmpval = evalin('caller', setglob{1});
                        tmpstakk.(setglob{1}) = tmpval;
                    end
                end

                % store locals in tmpstakk
                for i = 1:length(locvar)
                    tmpval = evalin('caller', locvar(i).name);
                    tmpstakk.(locvar(i).name) = tmpval;
                end
                
                % create unique stakkname in base and store stakk in base
                while evalin('base',['exist(''' stakkname ''')'])
                    storenum = storenum + 1;
                    stakkname = [storeprefix int2str(storenum)];
                end
                
                assignin('base', stakkname, struct(tmpstakk));
                
            otherwise
                error('stakk.m: unidentifiable 2-parameter usage. See ''help stakk'' for more information');
        end
    case 3
        % push(regexp, lagername), compare(lager1, lager2)
        switch inputcell{1}
            case 'push'
                % pushes regexp-selected variables in <lagername>
                
                ver = version; % check whether '-regexp' in 'whos' below works...
                if str2num(ver(1))<7
                    error('stakk.m: regular expression works in Matlab 7.0 and greater');
                end
                
                regulexp = inputcell{2}
                lagername = inputcell{3}
                if isempty(storenum)
                   storenum = 0; % part of lager name
                end
                storenum = storenum + 1;
                                
                % build two lists of local and global vars
                allvar = evalin('caller',['whos(''-regexp'', ''' regulexp ''')']);
                globvar = evalin('caller',['whos(''global'', ''-regexp'', ''' regulexp ''')']);
                
                setall = {allvar.name}; % names of all vars in caller
                setglob = {globvar.name}; % names of all global vars in caller
                setglob = intersect(setglob, setall); % take only globals
                % that are declared global in caller's workspace
                [ignore, locidx] = setdiff(setall, setglob);
                locvar = allvar(locidx); % list of all local variables in caller
                
                
                % if globals should be included...
                if showGlobals
                    for i = 1:length(setglob)
                        tmpval = evalin('caller', setglob{1});
                        tmpstakk.(setglob{1}) = tmpval;
                    end
                end

                % store locals in tmpstakk
                for i = 1:length(locvar)
                    tmpval = evalin('caller', locvar(i).name);
                    tmpstakk.(locvar(i).name) = tmpval;
                end
                
                % check if lagername in base is unique
                while evalin('base',['exist(''' lagername ''')'])
                    storenum = storenum + 1;
                    neulager = [lagername int2str(storenum)];
                    warning('stakk:NAME',...
                        'stakk.m: the lagername %s already exists in base! I try %s', ...
                        lagername, neulager);
                    lagername = neulager;
                end
                
                % store stakk in base under unique name lagername
                assignin('base', lagername, struct(tmpstakk));
                stakkname = lagername; % copy return value
                
            case 'compare'
                % compare two different stakks
                lager1 = inputcell{2};
                lager2 = inputcell{3};
                if ~(strcmp(class(lager1),'char') && strcmp(class(lager2),'char'))
                    error('stakk.m: use compare with two struct names given as char.');
                end
                
                % get actual & set new format spacing
                formspace = get(0,'FormatSpacing');
                format('compact');
                
                % check whether the two lagers are existing and of the
                % correct type
                chk1 = evalin('base',['exist(''' lager1 ''')']);
                chk2 = evalin('base',['exist(''' lager2 ''')']);
                if ~(chk1 && chk2)
                    error('stakk.m: non-existing %s and %s! Comparison not possible.', lager1, lager2);
                end
                chk1 = evalin('base',['isstruct(' lager1 ')']);
                chk2 = evalin('base',['isstruct(' lager2 ')']);
                if ~(chk1 && chk2)
                    error('stakk.m:  %s and %s must be structs! Comparison not possible.', lager1, lager2);
                end
                
                % get fieldnames of each struct
                names1 = evalin('base',['fieldnames(' lager1 ')']);
                names2 = evalin('base',['fieldnames(' lager2 ')']);
                disp(['Total number of variables in '...
                    lager1 ': ' num2str(length(names1))]);
                disp(['Total number of variables in '...
                    lager2 ': ' num2str(length(names2))]);

                % check (exclusive-or) objects of both sets
                [xornames, id1, id2] = setxor(names1, names2);
                if isempty(xornames)
                    disp(['Identical list of variable names in '...
                        lager1 ' and ' lager2 '.']);
                    diffnames = 0;
                else
                    disp(['Different list of variable names in '...
                        lager1 ' and ' lager2 '.']);
                    if ~isempty(id1)
                        disp([num2str(length(id1)) ...
                            ' variables exclusively present in ' lager1 ':']);
                        disp(names1(id1));
                    end
                    if ~isempty(id2)
                        disp([num2str(length(id2)) ...
                            ' variables exclusively present in ' lager2 ':']);
                        disp(names2(id2));
                    end
                    diffnames = length(xornames);
                end
                disp('-----------------------------------------------');

                % check contents of variables with common names
                [andnames, id1, id2] = intersect(names1, names2);
                numnames = length(andnames); % number of variables in intersection
                diffcont = 0; % number of different contents
                difftype = 0; % number of different types
                diffdims = 0; % number of different dimensions
                diffsize = 0; % number of different sizes
                difffields = 0; % number of structs with different fields
                
                for i = 1:length(andnames)
                    var1 = evalin('base',[lager1 '.' andnames{i}]);
                    var2 = evalin('base',[lager2 '.' andnames{i}]);
                    typ1 = evalin('base',['class(' lager1 '.' andnames{i} ')']);
                    typ2 = evalin('base',['class(' lager2 '.' andnames{i} ')']);
                    size1 = evalin('base',['size(' lager1 '.' andnames{i} ')']);
                    size2 = evalin('base',['size(' lager2 '.' andnames{i} ')']);
                    dimstri1 = sprintf('%dx',size1);
                    dimstri1 = dimstri1(1:end-1);
                    dimstri2 = sprintf('%dx',size2);
                    dimstri2 = dimstri2(1:end-1);




                    if size1(1)>1
                        firstrow1 = ' (first row below)';
                    else
                        firstrow1 = '';
                    end
                    if size2(1)>1
                        firstrow2 = ' (first row below)';
                    else
                        firstrow2 = '';
                    end

                    if strcmp(typ1,typ2)==0  % same name but different type
                        disp(['Variable found with different type:    ' andnames{i}]);
                        disp([' in ' lager1 ': ' dimstri1 ' ' class(var1) firstrow1]);
                        if ~isempty(var1), disp(var1(1,:)); end
                        disp([' in ' lager2 ': ' dimstri2 ' ' class(var2) firstrow2]);
                        if ~isempty(var2), disp(var2(1,:)); end
                        difftype = difftype + 1;
                    else % same name and type, probably different size & content
                        if length(size1) == length(size2) % same num of dims?
                            sizecomp = size1 == size2; % compare sizes
                            numdiffsize = length(size1)-sum(sizecomp);...
                                % number of differently-sized dimensions
%                             disp([andnames{i} ': matching number of dimensions in '...
%                                lager1 ' and ' lager2 '.']);

                            switch typ1
                                case 'struct'
                                    fields1 = evalin('base',['fieldnames('...
                                        lager1 '.' andnames{i} ')']);
                                    fields2 = evalin('base',['fieldnames('...
                                        lager2 '.' andnames{i} ')']);
                                    [xorfields, if1, if2] = setxor(fields1, fields2);
                                    if isempty(xorfields)
%                                         disp([' Equal 1st-level fieldnames found in struct: '...
%                                             andnames{i}]);
                                        if ~isequalwithequalnans(var1, var2)
                                            diffcont = diffcont + 1;
                                            disp(['Different contents found in struct:    ' andnames{i}]);
                                            disp(['  (idential 1st-level fieldnames)']);
                                            % disp(['  in ' lager1 ': ']);
                                            % disp(var1);
                                            % disp(['  in ' lager2 ': ']);
                                            % disp(var2);
                                        end
                                    else % structs with different fieldnames
                                        difffields = difffields + 1;
                                        disp(['Different 1st-level fieldnames found in struct    '...
                                                andnames{i}]);
                                        if ~isempty(if1)
                                            disp([ '  only in ' lager1 ': ']);
                                            disp(fields1(if1));
                                        end
                                        if ~isempty(if2)
                                            disp([ '  only in ' lager2 ': ']);
                                            disp(fields2(if2));
                                        end
                                    end
                                otherwise
                                    if ~isequalwithequalnans(var1, var2)
                                        diffcont = diffcont + 1;
                                        disp(['Difference found in variable:    ' andnames{i}]);
                                        
                                        disp([' in ' lager1 ': ' dimstri1 ' ' class(var1) firstrow1]);
                                        if ~isempty(var1), disp(var1(1,:)); end
                                        disp([' in ' lager2 ': ' dimstri2 ' ' class(var2) firstrow2]);
                                        if ~isempty(var2), disp(var2(1,:)); end
                                    end
                            end
                        else % same name & type, but different length(size(...))
                            diffdims = diffdims + 1;
                            disp(['Different number of dimensions for ' andnames{i}]);
                            disp([' in ' lager1 ': ' dimstri1 ' ' class(var1) ': (first row given)']);
                            if ~isempty(var1), disp(var1(1,:)); end
                            disp([' in ' lager2 ': ' dimstri2 ' ' class(var2) ': (first row given)']);
                            if ~isempty(var2), disp(var2(1,:)); end
                        end
                    end
                end

                disp('-----------------------------------------------');
                if ~diffcont && ~diffnames && ~diffdims && ~difffields
                    disp(['The two storage structs ' lager1 ' and ' lager2 ' are identical.']);
                else
                    disp([num2str(diffnames) ' variables are found only in one of the two storage structs.']);
                    disp(['A total of ' num2str(diffcont) ...
                        ' different contents have been found within the']);
                    disp(['total ' num2str(numnames) ...
                        ' variables of the intersection of ' lager1 ...
                        ' and ' lager2 '.']);
                    disp([num2str(diffdims)...
                        ' variables have a different number of dimensions, and']);
                    disp([num2str(difffields)...
                        ' have different fieldnames (contents were not compared).']);
                end
                
                % restore previous formatspacing
                format(formspace);
            otherwise
                error('stakk.m: unidentifiable 3-parameter usage. See ''help stakk'' for more information');
        end
end
% En Taro Adun!
