function writeBinFile(fullfilename, data, vectorPeriod, parmKind)
%WRITEBINFILE creates a binary HTK coefficient file
% Inputs:
% data - coefficient matrix
% fullfilename - intended file to be written to.
% vectorPeriod - sample period in 100ns units (4 byte int)
% parmKind - code for the sample kind (2 byte int)

% Other variables
% numVectors - number of vectors in file (4 byte int)
% numDims - number of bytes per vector (2 byte int)
    
    fid                         = fopen(fullfilename, 'w', 'ieee-be');
    [numVectors, numDims]       = size(data);

    % Write the header information%
    fwrite(fid, numVectors, 'int32');
    fwrite(fid, vectorPeriod, 'int32');
    fwrite(fid, numDims * 4, 'int16');
    fwrite(fid, parmKind, 'int16');

    % Write the data: one coefficient at a time:
    for i = 1: numVectors
        for j = 1:numDims
            fwrite(fid, data(i, j), 'float32');
        end
    end

    fclose(fid);
end