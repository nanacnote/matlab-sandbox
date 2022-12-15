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

lin_filter_exp_folder               = "experiments/withLinFil/";
tri_filter_exp_folder               = "experiments/withTriMelFil/";
energy_exp_folder                   = "experiments/withEnergy/";
velocity_exp_folder                 = "experiments/withVel/";
acceleration_exp_folder             = "experiments/withAcc/";

recordings                          = dir(rec_folder);
recordings_size                     = length(recordings);

htk_param_kind      = 9;
filter_band_size    = 8;
frame_size          = 320;
frame_time_ms       = 10;
frame_time_ns       = 100000.0;

% loop over all recordings and perform feature extraction
for file_index = 1:recordings_size
    if recordings(file_index).isdir == 0
        wav_filename                = recordings(file_index).name;
        [data, sf]                  = audioread(strcat(rec_folder, wav_filename));
        data_size                   = length(data);
        frame_count                 = floor(data_size/frame_size);
        hop_size                    = frame_size/2;
        vector_rows_size            = frame_count*2-1;
        vector_columns_size         = filter_band_size;
        lpcc                        = zeros(vector_rows_size, vector_columns_size); % linear prediction cepstral coefficient
        mfcc                        = zeros(vector_rows_size, vector_columns_size); % mel frequency cepstral coefficient


        % FEATURE EXTRACTION STAGE
        loop_counter = 0;
        for frame_index = 1:hop_size:data_size
            loop_counter = loop_counter + 1;
            if frame_index < data_size - hop_size
                data_slice                          = data(frame_index:min(frame_index+frame_size-1, data_size));
                [mag, phase]                        = magAndPhase(data_slice);
                halfed_mag                          = mag(1:frame_size/2);

                % applying linear filter bank to generate LPCC
                linear_filtered_vec                 = applyLinearRectFilterbank(filter_band_size, halfed_mag);
                linear_cepstrum                     = log(linear_filtered_vec);
                lpcc(loop_counter,:)                = dct(linear_cepstrum);
                
                % applying mel triangle filter bank to generate MFCC
                mel_triangle_filtered_vec           = applyMelTriangleFilterbank(filter_band_size, halfed_mag);
                mel_cepstrum                        = log(mel_triangle_filtered_vec);
                mfcc(loop_counter,:)                = dct(mel_cepstrum);
            end
        end
        
        % ENERGY | VELOCITY | ACCELERATION FEATURE CALCULATION
        mfcc_e                                      = calcEnergyVec(mfcc);
        mfcc_vel                                    = calcVelVec(mfcc);
        mfcc_acc                                    = calcAccVec(mfcc_vel);
        
        % BINARY FILES WRITING STAGE
        [path_, filename_without_ext, extension_]   = fileparts(wav_filename);

         writeBinFile(strcat(lin_filter_exp_folder, "vectors/", session_type, "/", filename_without_ext), lpcc, frame_time_ns, htk_param_kind);
         writeBinFile(strcat(tri_filter_exp_folder, "vectors/", session_type, "/", filename_without_ext), mfcc, frame_time_ns, htk_param_kind);
         writeBinFile(strcat(energy_exp_folder, "vectors/", session_type, "/", filename_without_ext), mfcc_e, frame_time_ns, htk_param_kind);
         writeBinFile(strcat(velocity_exp_folder, "vectors/", session_type, "/", filename_without_ext), mfcc_vel, frame_time_ns, htk_param_kind);
         writeBinFile(strcat(acceleration_exp_folder, "vectors/", session_type, "/", filename_without_ext), mfcc_acc, frame_time_ns, htk_param_kind);
    end
end

% LIB AND LIST FILES GENERATION STAGE
genListAndLibFiles(lin_filter_exp_folder, 8, session_type);
genListAndLibFiles(tri_filter_exp_folder, 8, session_type);
genListAndLibFiles(energy_exp_folder, 9, session_type);
genListAndLibFiles(velocity_exp_folder, 16, session_type);
genListAndLibFiles(acceleration_exp_folder, 24, session_type);

disp("Successfully generated all files!");

return;
