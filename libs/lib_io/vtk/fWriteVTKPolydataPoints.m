function fWriteVTKPolydataPoints(filename,bBinary,P,varargin )
    % Write points data to VTK file
    % 
    % P: Points, preferably (3 x n), otherwise (n x 3) will be transposed
    % varargin: 
    %      - lists of pair arguments  'varname',var  where vart is scalar (1xn) or vector (3xn)



    % --------------------------------------------------------------------------------
    % --- Default arguments 
    % --------------------------------------------------------------------------------
    close all;
    if ~exist('filename','var'); filename = 'test.vtk'; end
    if ~exist('P'       ,'var'); P        = eye(3,3); end
    if ~exist('bBinary' ,'var'); bBinary  = true; end

    % --------------------------------------------------------------------------------
    % --- Safety checks on inputs 
    % --------------------------------------------------------------------------------
    if size(P,1)~=3 ; P=P'; end % transposing input if required
    np=size(P,2);


    fid = fopen(filename, 'w'); 
    fprintf(fid, '# vtk DataFile Version 2.0\n');
    fprintf(fid, '\n');
    if bBinary
        fprintf(fid, 'BINARY\n');
    else
        fprintf(fid, 'ASCII\n');
    end
    fprintf(fid, 'DATASET POLYDATA\n');
    fprintf(fid, 'POINTS %d float\n',np);

    % --------------------------------------------------------------------------------
    % --- Point coordinates 
    % --------------------------------------------------------------------------------
    if bBinary
        fwrite(fid, P,'float','b');
    else
        fprintf(fid, '%.15e %.15e %.15e\n', P);
    end

    % --------------------------------------------------------------------------------
    % ---  Point data
    % --------------------------------------------------------------------------------
    if ~isempty(varargin)

        fprintf(fid, '\nPOINT_DATA %d\n',np);

        bLookupWritten=false;
        %  looping on pair of values 'varname',var
        for iv=1:floor(length(varargin)/2)
            varname = varargin{2*iv-1};
            M       = varargin{2*iv}  ;

            % --- Detecting scalar/vector and transposing if necessary
            if length(size(M))==1
                bScalar=true;
            elseif length(size(M))>2
                error('Can''t export variables of dimensions above 3')
            elseif size(M,1)==1 || size(M,2)==1
                bScalar=true;
            else
                bScalar=false;
                if size(M,1)~=3
                    M=M'; % transposition required
                end
            end
            if bScalar
                fprintf(fid,'\nSCALARS %s float\n',varname);
                if ~bLookupWritten
                    fprintf(fid,'LOOKUP_TABLE default\n');
                end
                bLookupWritten=true;
                if bBinary
                    fwrite(fid, M,'float','b');
                else
                    fprintf(fid, '%.15e\n', M);
                end
            else
                fprintf(fid,'\nVECTORS %s float\n',varname);
                if ~bLookupWritten
%                     fprintf(fid,'LOOKUP_TABLE default\n');
                end
                bLookupWritten=true;
                if bBinary
                    fwrite(fid, M,'float','b');
                else
                    fprintf(fid, '%.15e %.15e %.15e\n', M);
                end
            end
        end
    end
    fclose(fid);
