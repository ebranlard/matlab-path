function ftic(varargin) 
    % ftic: tic with more options. 
    % ftic records the "message" given as argument.
    % ftoc possibly display this message together with the elapsed time.
    % ftic and ftoc rely on the global variable TICTOC
    %
    % EXAMPLE:
    %    ftic('My message ');
    %    ftic('My message ', 'Erase', true)
    % 
    % AUTHOR: E. Branlard

    % --- Init of global variable if needed
    global TICTOC;
    if ~isfield(TICTOC,'Times')
        TICTOC.Times = cell(1,100);
        TICTOC.Names = cell(1,100) ;
        TICTOC.iHead = 0;
        TICTOC.bErase = false(1,100);
        TICTOC.nChar = 55;
    end
    % Incrementing head 
    TICTOC.iHead=TICTOC.iHead+1;

    % ---- Parsing arguments
    for iarg=2:2:nargin
        switch varargin{iarg}
            case 'Erase' 
                TICTOC.bErase(TICTOC.iHead)=varargin{iarg+1};
            otherwise 
                error('Option unknown %s',varargin{iarg})

        end % 
    end % loop on arguments


    %
    TICTOC.Times{TICTOC.iHead}=clock();
    if nargin>=1
        s=fStringEllipsis(varargin{1},TICTOC.nChar);
        s=fpad(s,TICTOC.nChar,'right',' ');
        fprintf('[....] %s\n',s);
        TICTOC.Names{TICTOC.iHead}=s;
    else
        TICTOC.Names{TICTOC.iHead}='';
    end
end

