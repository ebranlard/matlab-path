function [fs1, fs2,  er, missing1, missing2] = fCompare(s1,s2,n1,n2,tol,debug)
    %
    % check two structures for differances - i.e. see if strucutre s1 == structure s2
    % function [fs1, fs2, er] = compare(s1,s2,n1,n2,p,tol)
    %
    % s1      structure one                              class structure
    % s2      structure two                              class structure - optional
    % n1      first structure name (variable name)       class char - optional
    % n2      second structure name (variable name)      class char - optional
    %
    % Author: Emmanuel Branlard
    % Revisions: May 2011 - January 2015
    %
    if nargin < 3; n1 = 's1'; end
    if nargin < 4; n2 = 's2'; end
    if nargin < 5; tol = 1e-16; end
    if nargin < 6; debug = false; end



    % define fs
    fs1 = {}; fs2 = {}; er = {};


    % are the variables structures
    if isstruct(s1) || isobject(s1)
        % --------------------------------------------------------------------------------
        % ---  Structures / Objects
        % --------------------------------------------------------------------------------
        if debug;  fprintf('Struct Compare: %s and %s...\n',n1,n2); end;
        [fs1, fs2,  er, missing1, missing2] = compare_struct(s1,s2,n1,n2,tol);
    elseif isa(s1,'sym')
        % --------------------------------------------------------------------------------
        % --- Symbolic expressions
        % --------------------------------------------------------------------------------
        if debug;  fprintf('Symbol Compare: %s and %s...\n',n1,n2); end;
        [fs1, fs2,  er, missing1, missing2] = compare_symb(s1,s2,n1,n2,tol);

    elseif isstr(s1)
        % --------------------------------------------------------------------------------
        % ---  Strings
        % --------------------------------------------------------------------------------
        if debug;  fprintf('String Compare: %s and %s...\n',n1,n2); end;
        [fs1, fs2,  er, missing1, missing2] = compare_string(s1,s2,n1,n2,tol);
    elseif iscell(s1)
        % --------------------------------------------------------------------------------
        % ---  Cells
        % --------------------------------------------------------------------------------
        if debug; fprintf('Cell   Compare: %s and %s...\n',n1,n2); end;
        [fs1, fs2,  er, missing1, missing2] = compare_cell(s1,s2,n1,n2,tol); 
    elseif  length(s1)==1
        % --------------------------------------------------------------------------------
        % --- Scalar comparison
        % --------------------------------------------------------------------------------
        if debug; fprintf('Scalar Compare: %s and %s...\n',n1,n2); end;
        [fs1, fs2,  er, missing1, missing2] = compare_scalar(s1,s2,n1,n2,tol);
    else
        % --------------------------------------------------------------------------------
        % --- Arrays Compare
        % --------------------------------------------------------------------------------
        if debug; fprintf('Array  Compare: %s and %s...\n',n1,n2); end;
        [fs1, fs2,  er, missing1, missing2] = compare_array(s1,s2,n1,n2,tol);
    end
end



function [fs1, fs2,  er, missing1, missing2] = compare_struct(s1,s2,n1,n2,tol)
    fs1 = {}; fs2 = {}; er = {}; missing1={}; missing2={};
    % --------------------------------------------------------------------------------
    % ---  Structures / Objects
    % --------------------------------------------------------------------------------
    if isstruct(s1) && ~isstruct(s2)
        %one structure, one not
        fprintf('%s	%s		Type mismatch, First is structure, second is not\n',n1,n2);
        fs1 = cell(0,1); fs2 = fs1;
    elseif isobject(s1) && ~isequal(class(s1),class(s2))
        fprintf('%s	%s		Class mismatch, %s %s\n',n1,n2,class(s1),class(s2));
        fs1 = cell(0,1); fs2 = fs1;
    else
        fn1 = fieldnames(s1);
        fn2 = fieldnames(s2);

        maxlen1=max(cellfun(@length,fieldnames(s1)));
        maxlen2=max(cellfun(@length,fieldnames(s2)));
        global maxlen
        maxlen=max([maxlen1 maxlen2]);

        %	loop through structure 1 and match to structure 2
        pnt1 = zeros(1,length(fn1));
        for ii = 1:length(fn1)
            for jj = 1:length(fn2)
                if strcmp(fn1(ii),fn2(jj)); pnt1(ii) = jj; end
            end
        end
        pnt2 = zeros(1,length(fn2));
        for ii = 1:length(fn2)
            for jj = 1:length(fn1)
                if strcmp(fn2(ii),fn1(jj)); pnt2(ii) = jj; end
            end
        end
        %	get un-matched fields
        for ii = find(~pnt1)
            fprintf('>>>Error: %s.%s Not found in other\n',n1,char(fn1(ii)));
            fs1 = [fs1; {[char(n1) '.' char(fn1(ii))]}];
            fs2 = [fs2; {''}]; er = [er; {'Un-matched'}];
        end
        for ii = find(~pnt2)
            fprintf('>>>Error: %s.%s Not found in other\n',n2,char(fn2(ii)));
            fs2 = [fs2; {[char(n2) '.' char(fn2(ii))]}];
            fs1 = [fs1; {''}]; er = [er; {'Un-matched'}];
        end
        % MANU
        %missing1=fs1(~cellfun(@isempty,fs1));
        %missing2=fs2(~cellfun(@isempty,fs2));
        %
        pnt1i = find(pnt1); pnt2i = find(pnt2);
        for ii=1:numel(pnt1i)
            %		added loop for indexed structured variables
            for jj = 1:size(s1,2)
                %			clean display - add index if needed
                if size(s1,2) == 1
                    n1p = [n1 '.' char(fn1(pnt1i(ii)))];
                    n2p = [n2 '.' char(fn2(pnt2i(ii)))];
                else
                    n1p = [n1 '(' num2str(jj) ').' char(fn1(ii))]; ...
                        n2p = [n2 '(' num2str(jj) ').' char(fn2(pnt2(ii)))];
                end
                [fss1 fss2 err] = compare(getfield(s1(jj),char(fn1(pnt1i(ii)))), ...
                    getfield(s2(jj),char(fn2(pnt2i(ii)))),n1p,n2p,tol);
                if ~iscell(err); err = cellstr(err); end
                fs1 = [fs1; fss1]; fs2 = [fs2; fss2]; er = [er; err];
            end
        end
    end
end

function [fs1, fs2,  er, missing1, missing2] = compare_symb(s1,s2,n1,n2,tol)
    fs1 = {}; fs2 = {}; er = {}; missing1={}; missing2={};
    % --------------------------------------------------------------------------------
    % --- Symbolic expressions
    % --------------------------------------------------------------------------------
    if ~isa(s2,'sym')
        fprintf('%s	%s		Type mismatch, First is symbolic, second is not\n',n1,n2);
        fs1 = cell(0,1); fs2 = fs1;
    else
        %	compare two symbolic expresions
        %	direct compare
        [ss1 r] = simple(s1); [ss2 r] = simple(s2);
        t = isequal(simplify(ss1),simplify(ss2));
        if ~t
            %		could still be equal, but not able to reduce the symbolic expresions
            %		get factors
            f1 = findsym(ss1); f2 = findsym(ss2);
            w = warning; 
            if isequal(f1,f2)
                %			same symbolic variables.  same eqn?
                temp = [1 findstr(f1,' ') + 1]; tres = NaN * zeros(1,30);
                for jj = 1:1e3
                    ss1e = ss1; ss2e = ss2;
                    for ii = 1:length(temp);
                        tv = (real(rand^rand)) / (real(rand^rand));
                        ss1e = subs(ss1e,f1(temp(ii)),tv);
                        ss2e = subs(ss2e,f2(temp(ii)),tv);
                    end
                    %			check for match
                    if isnan(ss1e) || isnan(ss2e)
                        tres(jj) = 1;
                    elseif (double(ss1e) - double(ss2e)) < tol
                        tres(jj) = 1;
                    end
                end
                %			now check symbolic equation results
                if sum(tres) == length(tres)
                    %				symbolics assumed to be the same equation
                    t = 1;
                end
            else
                %			different symbolic variables
            end
            warning(w)
        end
        if ~t
            fprintf('%s do NOT match\n');
            fs1 = n1; fs2 = n2; er = 'Symbolic disagreement';
        end
    end
end


function [fs1, fs2,  er, missing1, missing2] = compare_string(s1,s2,n1,n2,tol)
    fs1 = {}; fs2 = {}; er = {}; missing1={}; missing2={};
    % --------------------------------------------------------------------------------
    % ---  Strings
    % --------------------------------------------------------------------------------
    if ~isstr(s2)
        fprintf('%s	%s		Type mismatch, First is String, second is not\n',n1,n2);
        fs1 = cell(0,1); fs2 = fs1;
    elseif ~isequal(s1,s2)
        fprintf('%s %s do NOT match\n',n1);
        fs1 = n1; fs2 = n2; er = 'String mismatch';
    end
end

function [fs1, fs2,  er, missing1, missing2] = compare_cell(s1,s2,n1,n2,tol)
    fs1 = {}; fs2 = {}; er = {}; missing1={}; missing2={};
    % --------------------------------------------------------------------------------
    % ---  Cells
    % --------------------------------------------------------------------------------
    if ~iscell(s2)
        fprintf('%s	%s		Type mismatch, First is Cell, second is not\n',n1,n2);
        fs1 = cell(0,1); fs2 = fs1;
    elseif ~strcmp(num2str(size(s1)),num2str(size(s2)));
        fprintf('%s %s	no -> Different sizes\n',n1);
        fs1 = [fs1; {n1}]; fs2 = [fs2; {n2}]; er = [er; {'String size error'}];
    else
        % For now we loop as a linear thing
        for jj =1:length(s1)
            n1p=sprintf('%s{%d}',n1,jj);
            n2p=sprintf('%s{%d}',n2,jj);
            [fss1 fss2 err] = compare(s1{jj},s2{jj},n1p,n2p,tol);
            if ~iscell(err); err = cellstr(err); end
            fs1 = [fs1; fss1]; fs2 = [fs2; fss2]; er = [er; err];
        end

    end
end

function [fs1, fs2,  er, missing1, missing2] = compare_scalar(s1,s2,n1,n2,tol)
    fs1 = {}; fs2 = {}; er = {}; missing1={}; missing2={};
    % --------------------------------------------------------------------------------
    % --- Scalar
    % --------------------------------------------------------------------------------
    if s1~=s2
        fprintf('%s do NOT match\n',n1);
        fs1 = n1; fs2 = n2; er = 'String mismatch';
    end
end

function [fs1, fs2,  er, missing1, missing2] = compare_array(s1,s2,n1,n2,tol)
    fs1 = {}; fs2 = {}; er = {}; missing1={}; missing2={};
    % --------------------------------------------------------------------------------
    % --- Arrays 
    % --------------------------------------------------------------------------------
    if strcmp(num2str(size(s1)),num2str(size(s2)));
        % structures are same size - check for precision error if numbers
        if isempty(s1) && isempty(s2)
            %
        else
            AbsErr   = max(abs(s1(:)-s2(:)))                       ;
            Delta = (max([s1(:)' s2(:)'])- min([s1(:)' s1(:)']));
            if  AbsErr > tol * Delta
                %				same size, diferent values or not numbers
                fprintf('>>> Error: %s no ->  ',n1);
                fs1 = [fs1; {n1}]; fs2 = [fs2; {n2}]; er = [er; {'?'}];
                if(length(s1)>1)
                    fprintf('Max error (%%) = %g%% \n', AbsErr /Delta);
                else
                    fprintf('%s \n',['values:  ',num2str(s1),'  ', num2str(s2)]);
                end
            else
                % tolerance agreement
                fprintf('%s tolerance match (%e)\n',n1,tol);
            end
        end
    else
        %			size difference
        fprintf('%s %s	no -> Different sizes\n',n1);
        fs1 = [fs1; {n1}]; fs2 = [fs2; {n2}]; er = [er; {'String size error'}];
    end
end

