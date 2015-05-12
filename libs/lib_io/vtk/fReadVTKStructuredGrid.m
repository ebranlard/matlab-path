function [Data,Grid]=fReadVTKStructuredGrid(filename)
    % This matlab scripts read Structured Grid of legacy VTK, ascii or binary
    % Binary data are assumed to be big endian double. This can be adapted to single.
    % The function is not general but can be adapted. It only reads vectors, but point data is easy to do.

    %% Init
    Data=[];
    Grid=[];

    fid=fopen(filename,'r');
    % Reading header
    fgetl(fid); % comment
    Data.name      = fgetl(fid) ;  % name
    Data.file_type = fgetl(fid) ;  % type
    if (isequal(lower(Data.file_type),'ascii'))
        bBinary=false;
    elseif (isequal(lower(Data.file_type),'binary'))
        bBinary=true;
        error('Binary not implemented yet. Check fReadVTKRectilinearGrid.m for help')
    else
        error('Unknown file type')
    end
    
    
    [ln,allgood,wrds]=fReadTillKeyword(fid,'DATASET');
    % Reading dimensions
    wrds=textscan(fgetl(fid),'%*s %d %d %d');
    Grid.n1=wrds{1};
    Grid.n2=wrds{2};
    Grid.n3=wrds{3};
    fgetl(fid);
    Buffer=textscan(fid,'%f %f %f',Grid.n1*Grid.n2*Grid.n3,'CollectOutput',true);
    % Grid Info
    if(nargout>1)
        Buffer=Buffer{1};
        Grid.v1=unique(Buffer(:,1));
        Grid.v2=unique(Buffer(:,2));
        Grid.v3=unique(Buffer(:,3));
        [X,Y,Z]=meshgrid(Grid.v1,Grid.v2,Grid.v3);
        XX=permute(reshape(Buffer(:,1),[Grid.n1,Grid.n2,Grid.n3]),[2,1,3]);
        YY=permute(reshape(Buffer(:,2),[Grid.n1,Grid.n2,Grid.n3]),[2,1,3]);
        ZZ=permute(reshape(Buffer(:,3),[Grid.n1,Grid.n2,Grid.n3]),[2,1,3]);
        if (~isequal(XX,X) || ~isequal(YY,Y) || ~isequal(ZZ,Z))
            warning('not constructing CPs correctly')
            kbd
        end
        Grid.X=X;
        Grid.Y=Y;
        Grid.Z=Z;
    end
    [ln,allgood,wrds]=fReadTillKeyword(fid,'VECTORS');
    Buffer=textscan(fid,'%f %f %f',Grid.n1*Grid.n2*Grid.n3,'CollectOutput',true);
    Buffer=Buffer{1};
    Data.U=permute(reshape(Buffer(:,1),[Grid.n1,Grid.n2,Grid.n3]),[2,1,3]);
    Data.V=permute(reshape(Buffer(:,2),[Grid.n1,Grid.n2,Grid.n3]),[2,1,3]);
    Data.W=permute(reshape(Buffer(:,3),[Grid.n1,Grid.n2,Grid.n3]),[2,1,3]);
    fclose(fid);
