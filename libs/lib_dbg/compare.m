function compare(lager1,lager2)
% compare two different stakks generated with command stakk
%                 lager1 = inputcell{2};
%                 lager2 = inputcell{3};
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
                                   fprintf('\nVARIABLE:   %s - Structure Comparison\n', andnames{i});
                                   fprintf('----------------------\n');
                                    [~,~,~,m1,m2]=comp_struct([lager1,'.',andnames{i}],[lager2,'.',andnames{i}]);
                                    disp(['Fields Missing in ', lager1,'.',andnames{i} ]);
                                    disp(m1);
                                    disp(['Fields Missing in ', lager2,'.',andnames{i} ]);
                                    disp(m2);
%                                     fields1 = evalin('base',['fieldnames('...
%                                         lager1 '.' andnames{i} ')']);
%                                     fields2 = evalin('base',['fieldnames('...
%                                         lager2 '.' andnames{i} ')']);
%                                     [xorfields, if1, if2] = setxor(fields1, fields2);
%                                     if isempty(xorfields)
% %                                         disp([' Equal 1st-level fieldnames found in struct: '...
% %                                             andnames{i}]);
%                                         if ~isequalwithequalnans(var1, var2)
%                                             diffcont = diffcont + 1;
%                                             disp(['Different contents found in struct:    ' andnames{i}]);
%                                             disp(['  (idential 1st-level fieldnames)']);
%                                             % disp(['  in ' lager1 ': ']);
%                                             % disp(var1);
%                                             % disp(['  in ' lager2 ': ']);
%                                             % disp(var2);
%                                         end
%                                     else % structs with different fieldnames
%                                         difffields = difffields + 1;
%                                         disp(['Different 1st-level fieldnames found in struct    '...
%                                                 andnames{i}]);
%                                         if ~isempty(if1)
%                                             disp([ '  only in ' lager1 ': ']);
%                                             disp(fields1(if1));
%                                         end
%                                         if ~isempty(if2)
%                                             disp([ '  only in ' lager2 ': ']);
%                                             disp(fields2(if2));
%                                         end
%                                     end
                                otherwise
                                    if ~isequalwithequalnans(var1, var2)
                                        diffcont = diffcont + 1;
                                        fprintf('\nVARIABLE:   %s\n', andnames{i});
                                        fprintf('----------------------\n');
                                        if(length(size1)==2)
                                            stransp='';
                                            %MATRICES and vectors
                                            if(mean(size1(1:2)==size2(2:-1:1))==1)
                                                stransp='TRANSPOSED !!!';
                                                if(size1(2)==1) % column vector
                                                    %they are transposed
                                                    var1=var1';
                                                else
                                                    var2=var2';
                                                end
                                            end
                                            colMax=min(size(var1,2),32); 
                                            fprintf('  %s: %s - %s: %s (%s-%s)   %s \n',lager1,dimstri1,lager2,dimstri2,class(var1),class(var2),stransp)
                                            disp(var1(1,1:colMax)-var2(1,1:colMax));
                                            fprintf('\n  Max diff: %f\n',max(max(var2-var1)));
                                        else
                                            disp([' in ' lager1 ': ' dimstri1 ' ' class(var1) firstrow1]);
                                            if ~isempty(var1), disp(var1(1,:)); end
                                            disp([' in ' lager2 ': ' dimstri2 ' ' class(var2) firstrow2]);
                                            if ~isempty(var2), disp(var2(1,:)); end
                                        end
                                    else
%                                         fprintf('\nVARIABLE:   %s  - EQUAL\n', andnames{i});
%                                         fprintf('----------------------\n');
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
                

