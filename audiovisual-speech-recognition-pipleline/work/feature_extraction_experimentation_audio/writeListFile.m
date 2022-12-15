function writeListFile(path, session_type)
%WRITELISTFILE creates a text file with a list of binary HTK coefficient file
% Inputs:
% path - directory to look up files

    bin_files             = dir(strcat(path, 'vectors/', session_type));
    fid                   = fopen(strcat(path, 'list/', session_type, '/', session_type, 'List'), 'w');

    for file_index = 1:length(bin_files)
        if bin_files(file_index).isdir == 0
            path
            fprintf(fid, strcat(path, 'vectors/', session_type, '/', bin_files(file_index).name, '\n'));
        end
    end

    fclose(fid);
end