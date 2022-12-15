% Speaker dependent speech recongintion feature extraction pipeline
% 
% Authors
%   Owusu K
%   Isreal O

clc
clear


% -------------------------------------------- %
if length(argv()) > 0
  session_type =  argv(){1}; 
else
    error("Session type argument is missing!");
endif
% -------------------------------------------- %


disp(strcat("Session --> ", session_type));
disp("Generating HTK files ...");

rec_folder                          = strcat("recordings/", session_type, "/");
sum_exp_folder                      = "experiments/withSum/";

recordings                          = dir(rec_folder);
recordings_size                     = length(recordings);

block_dimension     = 8;
htk_param_kind      = 9;
filter_band_size    = 8;
frame_size          = 320;
frame_time_ms       = 10;
frame_time_ns       = 100000.0;


% loop over all recordings and perform feature extraction
for file_index = 1:recordings_size
    if recordings(file_index).isdir
        cur_rec_dir_name            = recordings(file_index).name;
        cur_rec_dir_path            = strcat(rec_folder, cur_rec_dir_name);
        frames                      = dir(fullfile(cur_rec_dir_path, "*.jpg"));
        frames_length               = length(frames);
        data_cell                   = cell(1, frames_length);

        if frames_length
            
            % loop over all image frames in a recording and generate a data matix
            for i = 1:frames_length
                frame_data              = imread(fullfile(cur_rec_dir_path, frames(i).name));
                data_cell{i}            = truncatedDCT(frame_data, block_dimension, block_dimension);
            end

            data                        = cat(2, data_cell{:});
            data_size                   = length(data);
            frame_count                 = floor(data_size/frame_size);
            hop_size                    = frame_size/2;
            vector_rows_size            = frame_count*2-1;
            vector_columns_size         = 1;
            coefficient_vector          = zeros(vector_rows_size, vector_columns_size); 

            % FEATURE EXTRACTION STAGE
            loop_counter = 0;
            for frame_index = 1:hop_size:data_size
                loop_counter = loop_counter + 1;
                if frame_index < data_size - hop_size
                    data_slice                                        = data(frame_index:min(frame_index+frame_size-1, data_size));
                    coefficient_vector(loop_counter,:)                = sum(sum(data_slice, 1));
                end
            end

            % BINARY FILES WRITING STAGE
            writeBinFile(strcat(sum_exp_folder, "vectors/", session_type, "/", cur_rec_dir_name), coefficient_vector, frame_time_ns, htk_param_kind);
        end
    end
end

% LIB AND LIST FILES GENERATION STAGE
genListAndLibFiles(sum_exp_folder, vector_columns_size, session_type);

disp("Successfully generated all files!");

return;
