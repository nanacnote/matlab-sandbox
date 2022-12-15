function writeTxtFile(filepath,content)
%WRITETEXTFILE creates a file an populate with content 
% Inputs:
% filepath - path including filename to open
% content - text content to populate file with

    fid = fopen(filepath, 'w');
    fprintf(fid, content);
    fclose(fid);
end