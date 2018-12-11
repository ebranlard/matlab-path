function [fs1, fs2,  er, missing1, missing2] = compare(s1,s2,n1,n2,tol,bDebug)
    % Emmanuel Branlard
    % Revisions: May 2011 - January 2015
    %
    % check two variabls for differences - i.e. see if strucutre s1 == structure s2
    % function [fs1, fs2, er] = compare(s1,s2,top,n1,n2,debug)
    % INPUTS
    %   s1 : first variable
    %   s2 : seconf variable
    % INPUTS (optional)
    %   tol    : tolerance for numerics comparison.  Default 1e-16
    %   n1     : Name of first variable
    %   n2     : Name of second variable
    %   bDebug : Debug info 
    %
    %% Optional arguments
    if nargin < 3; n1 = 's1'; end
    if nargin < 4; n2 = 's2'; end
    if nargin < 5; tol = 1e-16; end
    if nargin < 6; bDebug = false; end

    %if bPrint
    %    fid=1; % standard output
    %else
    %    if ispc()
    %        fid = fopen('NUL:'    );  % Windows
    %    else
    %        fid = fopen('/dev/null'); % UNIX
    %    end
    %end




    % Init outputs
    fs1 = {}; fs2 = {}; er = {};
    % Switch depending on variable type
    if isstruct(s1) || isobject(s1)
        % --------------------------------------------------------------------------------
        % ---  Structures / Objects
        % --------------------------------------------------------------------------------
        if bDebug;  fprintf('Struct Compare: %s and %s...\n',n1,n2); end;
        [fs1, fs2,  er, missing1, missing2] = compare_struct(s1,s2,n1,n2,tol);
    elseif isa(s1,'sym')
        % --------------------------------------------------------------------------------
        % --- Symbolic expressions
        % --------------------------------------------------------------------------------
        if bDebug;  fprintf('Symbol Compare: %s and %s...\n',n1,n2); end;
        [fs1, fs2,  er, missing1, missing2] = compare_symb(s1,s2,n1,n2,tol);

    elseif ischar(s1)
        % --------------------------------------------------------------------------------
        % ---  Strings
        % --------------------------------------------------------------------------------
        if bDebug;  fprintf('String Compare: %s and %s...\n',n1,n2); end;
        [fs1, fs2,  er, missing1, missing2] = compare_string(s1,s2,n1,n2,tol);
    elseif iscell(s1)
        % --------------------------------------------------------------------------------
        % ---  Cells
        % --------------------------------------------------------------------------------
        if bDebug; fprintf('Cell   Compare: %s and %s...\n',n1,n2); end;
        [fs1, fs2,  er, missing1, missing2] = compare_cell(s1,s2,n1,n2,tol); 
    elseif  length(s1)==1
        % --------------------------------------------------------------------------------
        % --- Scalar comparison
        % --------------------------------------------------------------------------------
        if bDebug; fprintf('Scalar Compare: %s and %s...\n',n1,n2); end;
        [fs1, fs2,  er, missing1, missing2] = compare_scalar(s1,s2,n1,n2,tol);
    else
        % --------------------------------------------------------------------------------
        % --- Arrays Compare
        % --------------------------------------------------------------------------------
        if bDebug; fprintf('Array  Compare: %s and %s...\n',n1,n2); end;
        [fs1, fs2,  er, missing1, missing2] = compare_array(s1,s2,n1,n2,tol);
    end



function [fs1, fs2,  er, missing1, missing2] = compare_struct(s1,s2,n1,n2,tol)
    fs1 = {}; fs2 = {}; er = {}; missing1={}; missing2={};
    % --------------------------------------------------------------------------------
    % ---  Structures / Objects
    % --------------------------------------------------------------------------------
    if isstruct(s1) && ~isstruct(s2)
        %one structure, one not
        fprintf(2,'[FAIL] %s %s\t\t Type mismatch, First is structure, second is not\n',n1,n2);
        fs1 = cell(0,1); fs2 = fs1;
        if isobject(s2)
            fprintf(2,'      >>> continuing since s2 is an object...\n');
        else
            return
        end
        % Converting 
    end
    if isobject(s1) && ~isequal(class(s1),class(s2))
        fprintf(2,'[FAIL] %s %s\t\t Class mismatch, %s %s\n',n1,n2,class(s1),class(s2));
        fs1 = cell(0,1); fs2 = fs1;
        if isobject(s2)
            fprintf(2,'      >>> continuing anyway...\n');
        elseif isstruct(s2)
            fprintf(2,'      >>> continuing since s2 is a struct...\n');
        else
            return
        end
    end

    % --- Fields comparisions for objects and structures
    fn1 = fieldnames(s1);
    fn2 = fieldnames(s2);

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
        fprintf(2,'[FAIL] %s.%s\t\t Not found in other\n',n1,char(fn1(ii)));
        fs1 = [fs1; {[char(n1) '.' char(fn1(ii))]}];
        fs2 = [fs2; {''}]; er = [er; {'Un-matched'}];
    end
    for ii = find(~pnt2)
        fprintf(2,'[FAIL] %s.%s\t\t Not found in other\n',n2,char(fn2(ii)));
        fs2 = [fs2; {[char(n2) '.' char(fn2(ii))]}];
        fs1 = [fs1; {''}]; er = [er; {'Un-matched'}];
    end
    %missing1=fs1(~cellfun(@isempty,fs1));
    %missing2=fs2(~cellfun(@isempty,fs2));
    %
    pnt1i = find(pnt1); pnt2i = find(pnt2);
    for ii=1:length(pnt1)
        if pnt1(ii)>0 % i.e. this field is found in the other structure
            for jj = 1:size(s1,2)
                if size(s1,2) == 1
                    n1p = [n1 '.' char(fn1(ii))];
                    n2p = [n2 '.' char(fn2(pnt1(ii)))];
                else
                    n1p = [n1 '(' num2str(jj) ').' char(fn1(ii))]; ...
                    n2p = [n2 '(' num2str(jj) ').' char(fn2(pnt1(ii)))];
                end
                [fss1 fss2 err] = compare(getfield(s1(jj),char(fn1(ii))), ...
                    getfield(s2(jj),char(fn2(pnt1(ii)))),n1p,n2p,tol);
                if ~iscell(err); err = cellstr(err); end
                fs1 = [fs1; fss1]; fs2 = [fs2; fss2]; er = [er; err];
            end
        end
    end
%         pnt1i = find(pnt1); pnt2i = find(pnt2);
%         for ii=1:numel(pnt1i)
%             for jj = 1:size(s1,2)
%                 if size(s1,2) == 1
%                     n1p = [n1 '.' char(fn1(pnt1i(ii)))];
%                     n2p = [n2 '.' char(fn2(pnt2i(ii)))];
%                 else
%                     n1p = [n1 '(' num2str(jj) ').' char(fn1(ii))]; ...
%                     n2p = [n2 '(' num2str(jj) ').' char(fn2(pnt2(ii)))];
%                 end
%                 [fss1 fss2 err] = compare(getfield(s1(jj),char(fn1(pnt1i(ii)))), ...
%                     getfield(s2(jj),char(fn2(pnt2i(ii)))),n1p,n2p,tol);
%                 if ~iscell(err); err = cellstr(err); end
%                 fs1 = [fs1; fss1]; fs2 = [fs2; fss2]; er = [er; err];
%             end
%         end
end

function [fs1, fs2,  er, missing1, missing2] = compare_symb(s1,s2,n1,n2,tol)
    fs1 = {}; fs2 = {}; er = {}; missing1={}; missing2={};
    % --------------------------------------------------------------------------------
    % --- Symbolic expressions
    % --------------------------------------------------------------------------------
    if ~isa(s2,'sym')
        fprintf(2,'[FAIL] %s\t\t Type mismatch, First is symbolic, second is not\n',n1);
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
            fprintf(2,'[FAIL] %s\t\t expression mismatch\n',n1);
            fs1 = n1; fs2 = n2; er = 'Symbolic disagreement';
        end
    end
end


function [fs1, fs2,  er, missing1, missing2] = compare_string(s1,s2,n1,n2,tol)
    fs1 = {}; fs2 = {}; er = {}; missing1={}; missing2={};
    % --------------------------------------------------------------------------------
    % ---  Strings
    % --------------------------------------------------------------------------------
    if ~ischar(s2)
        fprintf(2,'[FAIL] %s\t\t Type mismatch, first is String, second is not\n',n1);
        fs1 = cell(0,1); fs2 = fs1;
    elseif ~isequal(s1,s2)
        fprintf(2,'[FAIL] %s\t\t strings mismatch: >%s< >%s< \n',n1,s1,s2);
        fs1 = n1; fs2 = n2; er = 'String mismatch';
    end
end

function [fs1, fs2,  er, missing1, missing2] = compare_cell(s1,s2,n1,n2,tol)
    fs1 = {}; fs2 = {}; er = {}; missing1={}; missing2={};
    % --------------------------------------------------------------------------------
    % ---  Cells
    % --------------------------------------------------------------------------------
    if ~iscell(s2)
        fprintf(2,'[FAIL] %s\t\t Type mismatch, First is Cell, second is not\n',n1);
        fs1 = cell(0,1); fs2 = fs1;
    elseif ~strcmp(num2str(size(s1)),num2str(size(s2)));
        fprintf(2,'[FAIL] %s\t\t Different sizes for cells\n',n1);
        fs1 = [fs1; {n1}]; fs2 = [fs2; {n2}]; er = [er; {'Cell size error'}];
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
        if isnumeric(s1)
            [fs1, fs2,  er, missing1, missing2] = compare_array(s1,s2,n1,n2,tol);
        else
            fprintf(2,'[FAIL] %s\t\t scalar mismatch\n',n1);
            fs1 = n1; fs2 = n2; er = 'Scalar mismatch';
        end
    else
        fprintf('[ OK ] %s\t\t \n',n1);
    end
end

function [fs1, fs2,  er, missing1, missing2] = compare_array(s1,s2,n1,n2,tol)
    fs1 = {}; fs2 = {}; er = {}; missing1={}; missing2={};
    % --------------------------------------------------------------------------------
    % --- Arrays 
    % --------------------------------------------------------------------------------
    if strcmp(num2str(size(s1)),num2str(size(s2)))
        % structures are same size - check for precision error if numbers
        if isempty(s1) && isempty(s2)
            fprintf('[ OK ] %s\t\t (empty)\n',n1);
        else
            s1=s1; s2=s2;

            AbsErr   = abs(s1-s2);
            % --- RelError TODO TODO Switch on method
            sref=(abs(s1)+abs(s2))/2;
            RelErr   = AbsErr./sref;
            %RelErr2  = abs(s1-s2)./s2;
            % --- Handling division by zero
            bZero=sref==0;
            RelErr(bZero)=0;
            % --- Handling signals very close to zero
            bSmall = sref<1e-8;
            RelErr(bSmall)=AbsErr(bSmall)/(1e-8);

            RelErr(AbsErr<eps)=0;
                
            MaxRelErr   = max(abs(RelErr(:)));
            if  MaxRelErr > tol 
                % same size, diferent values or not numbers
                fprintf(2,'[FAIL] %s\t\t ',n1);
                fs1 = [fs1; {n1}]; fs2 = [fs2; {n2}]; er = [er; {'Tolerance not matched'}];
                if(length(s1)>1)
                    fprintf('Max rel error = %g%% \n', MaxRelErr*100);
%                     for i=1:size(s1,1)
%                         fprintf(' %3d ',i);
%                         for j=1:size(s1,2)
%                             if abs(RelErr(i,j))>tol
%                                 fprintf(2,'%10.5f',RelErr(i,j)*100);
%                             else
%                                 fprintf(  '%10.5f',RelErr(i,j)*100);
%                             end
%                         end
%                         fprintf('\n');
%                     end
                    S='      ';
                    for j=1:size(s1,2)
                        S=sprintf('%s   %3d    ',S,j);
                    end
                    S=strcat(S,'\n');
                    fprintf(S)
                    for i=1:size(s1,1)
                        fprintf(' %3d ',i);
                        for j=1:size(s1,2)
                            if abs(RelErr(i,j))>tol
                                fprintf(2,'%10.5f',RelErr(i,j)*100);
                            else
                                fprintf(  '%10.5f',RelErr(i,j)*100);
                            end
                        end
                        fprintf('\n');
                    end
                    if size(s1,1)==1 || size(s1,2)==1
                        bWrong=abs(RelErr)>tol;
                        I=find(bWrong);
                        figure,hold all
                        plot(abs(RelErr)*100);
                        plot(I,abs(RelErr(bWrong))*100,'ko');
                        legend(['diff ' n1 ' / ' n2])
                        figure,hold all; 
                        plot(s1); plot(s2,'+'); legend(n1,n2)
                        plot(I,s1(bWrong),'ko');
                    end
                else
                    fprintf('values: %s - rel. %g%%\n',[num2str(s1),'  ', num2str(s2)],MaxRelErr*100);
                end
            else
                % tolerance agreement
                fprintf('[ OK ] %s\t\t tol. match (%.0e > %.0e)\n',n1,tol,MaxRelErr);
            end
            % -- Abs Error TODO TODO Switch on method
            %mmax=max([s1 s2]);
            %mmin=min([s1 s2]);
            %Delta = mmax - mmin;
            %MaxAbsErr   = max(abs(s1-s2))                       ;
            %if Delta==0; Delta=1; end;
            %if  MaxAbsErr > tol * Delta
            %    % same size, diferent values or not numbers
            %    fprintf(2,'[FAIL] %s\t\t ',n1);
            %    fs1 = [fs1; {n1}]; fs2 = [fs2; {n2}]; er = [er; {'Tolerance not matched'}];
            %    if(length(s1)>1)
            %        fprintf('Max error = %g%% \n', MaxAbsErr /Delta);
            %    else
            %        fprintf('%s \n',['values:  ',num2str(s1),'  ', num2str(s2)]);
            %    end
            %else
            %    % tolerance agreement
            %    fprintf('[ OK ] %s\t\t tol. match (%.0e > %.0e)\n',n1,tol,MaxAbsErr/Delta);
            %end
        end
    else
        % size difference
        fprintf(2,'[FAIL] %s\t\t Different sizes for arrays\n',n1);
        fs1 = [fs1; {n1}]; fs2 = [fs2; {n2}]; er = [er; {'Array size error'}];
    end
end

end
