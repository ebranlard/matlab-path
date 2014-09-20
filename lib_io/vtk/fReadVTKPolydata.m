function [Data]=fReadVTKPolydata(filename)

fid=fopen(filename,'r');
% Reading header
[ln,allgood,wrds]=fReadTillKeyword(fid,'DATASET');
if ~allgood
    error(['Can''t find the word DATASET in ' filename])
end
% Reading dimensions
wrds=textscan(fgetl(fid),'%*s %d %*s');
Data.np=wrds{1};
Data.Points=cell2mat(textscan(fid,'%f %f %f',Data.np,'CollectOutput',true));
%
[ln,allgood,wrds]=fReadTillNotEmpty(fid);
if ~allgood
    return
end
switch(lower(wrds{1}))
    case 'lines'
        Data.nl=str2num(wrds{2});
        nint=str2num(wrds{3});
        if (nint/Data.nl~=3)
            error('Script done only for segments')
        end
        % This below is not general it's only for segments..
        Data.Segments=cell2mat(textscan(fid,'%d %d %d',Data.nl,'CollectOutput',true));
    otherwise
        wrds
        error(['Keyword not understood for VTK polydata in ' filename])
end

%
[ln,allgood,wrds]=fReadTillNotEmpty(fid);
if ~allgood
    return
end
switch(lower(wrds{1}))
    case 'cell_data'
        disp(['cell_data todo in vtk polydata'])
%     % Reading
%     [ln,allgood,wrds]=fReadTillKeyword(fid,'DATASET');
    case 'point_data'
        disp(['point_data todo in vtk polydata'])
    otherwise
        wrds
        error(['Keyword not understood for VTK polydata in ' filename])
end


fclose(fid);
