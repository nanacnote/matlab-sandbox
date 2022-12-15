#!/bin/bash

# TODO: fix bc command not available to allow for floating point calculation and remove hard coded number
# TRAIN_TEST_SPLIT_THRESHOLD=$(echo "0.8 * $COUNT" | bc)
# TRAIN_TEST_SPLIT_THRESHOLD=20
TRAIN_TEST_SPLIT_THRESHOLD=8

RAW_DATA_FOLDER="raw"
LABS_FOLDER="labs"
WAVS_FOLDER="wavs"
JPGS_FOLDER="jpgs"

FEAT_EXTRACTION_AUDIO_RECORDINGS_TRAIN="../feature_extraction_experimentation_audio/recordings/train"
FEAT_EXTRACTION_AUDIO_RECORDINGS_TEST="../feature_extraction_experimentation_audio/recordings/test"
FEAT_EXTRACTION_AUDIO_LABELS_TRAIN="../feature_extraction_experimentation_audio/labels/train"
FEAT_EXTRACTION_AUDIO_LABELS_TEST="../feature_extraction_experimentation_audio/labels/test"

FEAT_EXTRACTION_VISUAL_RECORDINGS_TRAIN="../feature_extraction_experimentation_visual/recordings/train"
FEAT_EXTRACTION_VISUAL_RECORDINGS_TEST="../feature_extraction_experimentation_visual/recordings/test"
FEAT_EXTRACTION_VISUAL_LABELS_TRAIN="../feature_extraction_experimentation_visual/labels/train"
FEAT_EXTRACTION_VISUAL_LABELS_TEST="../feature_extraction_experimentation_visual/labels/test"



if [ "$1" = "genWAV" ]; then
    rm -r "$WAVS_FOLDER"; mkdir "$WAVS_FOLDER"
    for file in "$RAW_DATA_FOLDER"/*
        do
            OUTPUT=$(echo "$file" | sed "s/$RAW_DATA_FOLDER/$WAVS_FOLDER/")
            OUTPUT=$(echo "$OUTPUT" | sed "s/MP4/WAV/")
            ffmpeg -i "$file" -ar 16000 -ac 1 "$OUTPUT"
            # ffmpeg -i "$file" -vn -acodec pcm_s16le -ar 16000 -ac 2 "$OUTPUT"
        done
fi

if [ "$1" = "genJPG" ]; then
    for file in "$RAW_DATA_FOLDER"/*
        do
            WRAPPER_FOLDER=$(echo "$file" | sed "s/$RAW_DATA_FOLDER\///")
            WRAPPER_FOLDER=$(echo "$WRAPPER_FOLDER" | sed "s/.MP4//")
            rm -r "$JPGS_FOLDER/$WRAPPER_FOLDER"; mkdir "$JPGS_FOLDER/$WRAPPER_FOLDER"
            ffmpeg -i "$file" -vf fps=1/0.02 -vsync 0 -ar 16000 "$JPGS_FOLDER/$WRAPPER_FOLDER/%03d.jpg" 
        done
fi

if [ "$1" = "genCroppedJPG" ] && [ "$2" ]; then
    IFS=: read W H X Y <<< $2
    for file in "$RAW_DATA_FOLDER"/*
        do
            WRAPPER_FOLDER=$(echo "$file" | sed "s/$RAW_DATA_FOLDER\///")
            WRAPPER_FOLDER=$(echo "$WRAPPER_FOLDER" | sed "s/.MP4//")
            rm -r "$JPGS_FOLDER/$WRAPPER_FOLDER"; mkdir "$JPGS_FOLDER/$WRAPPER_FOLDER"
            ffmpeg -i "$file" -vf fps=1/0.02 -vsync 0 -ar 16000 "$JPGS_FOLDER/$WRAPPER_FOLDER/%03d.jpg"
            ffmpeg -i "$JPGS_FOLDER/$WRAPPER_FOLDER/%03d.jpg" -vf "crop=$W:$H:$X:$Y" "$JPGS_FOLDER/$WRAPPER_FOLDER/%03d.jpg"
        done
fi

if [ "$1" = "feedAudioPipeline" ]; then
    rm -r "$FEAT_EXTRACTION_AUDIO_RECORDINGS_TRAIN"; mkdir "$FEAT_EXTRACTION_AUDIO_RECORDINGS_TRAIN"
    rm -r "$FEAT_EXTRACTION_AUDIO_RECORDINGS_TEST"; mkdir "$FEAT_EXTRACTION_AUDIO_RECORDINGS_TEST"
    
    rm -r "$FEAT_EXTRACTION_AUDIO_LABELS_TRAIN"; mkdir "$FEAT_EXTRACTION_AUDIO_LABELS_TRAIN"
    rm -r "$FEAT_EXTRACTION_AUDIO_LABELS_TEST"; mkdir "$FEAT_EXTRACTION_AUDIO_LABELS_TEST"
    
    COUNT=0

    for file in "$WAVS_FOLDER"/*
        do
            WAV_FILE_PATH=$file
            LAB_FILE_PATH=$(echo "$WAV_FILE_PATH" | sed "s/$WAVS_FOLDER/$LABS_FOLDER/")
            LAB_FILE_PATH=$(echo "$LAB_FILE_PATH" | sed "s/WAV/LAB/")
            if [ $COUNT -lt $TRAIN_TEST_SPLIT_THRESHOLD ]; then
                cp -a "$WAV_FILE_PATH" "$FEAT_EXTRACTION_AUDIO_RECORDINGS_TRAIN"
                cp -a "$LAB_FILE_PATH" "$FEAT_EXTRACTION_AUDIO_LABELS_TRAIN"
                echo "COPIED -> $WAV_FILE_PATH -> TRAIN"
                echo "COPIED -> $LAB_FILE_PATH -> TRAIN"
            else
                cp -a "$WAV_FILE_PATH" "$FEAT_EXTRACTION_AUDIO_RECORDINGS_TEST"
                cp -a "$LAB_FILE_PATH" "$FEAT_EXTRACTION_AUDIO_LABELS_TEST"
                echo "COPIED -> $WAV_FILE_PATH -> TEST"
                echo "COPIED -> $LAB_FILE_PATH -> TEST"
            fi
            COUNT=$(($COUNT + 1))
        done
fi

if [ "$1" = "feedVisualPipeline" ]; then
    rm -r "$FEAT_EXTRACTION_VISUAL_RECORDINGS_TRAIN"; mkdir "$FEAT_EXTRACTION_VISUAL_RECORDINGS_TRAIN"
    rm -r "$FEAT_EXTRACTION_VISUAL_RECORDINGS_TEST"; mkdir "$FEAT_EXTRACTION_VISUAL_RECORDINGS_TEST"
    
    rm -r "$FEAT_EXTRACTION_VISUAL_LABELS_TRAIN"; mkdir "$FEAT_EXTRACTION_VISUAL_LABELS_TRAIN"
    rm -r "$FEAT_EXTRACTION_VISUAL_LABELS_TEST"; mkdir "$FEAT_EXTRACTION_VISUAL_LABELS_TEST"
    
    COUNT=0

    for folder in "$JPGS_FOLDER"/*
        do
            JPG_FOLDER_PATH=$folder
            LAB_FILE_PATH=$(echo "$JPG_FOLDER_PATH" | sed "s/$JPGS_FOLDER/$LABS_FOLDER/")
            LAB_FILE_PATH="$LAB_FILE_PATH.LAB"
            if [ $COUNT -lt $TRAIN_TEST_SPLIT_THRESHOLD ]; then
                cp -a "$JPG_FOLDER_PATH" "$FEAT_EXTRACTION_VISUAL_RECORDINGS_TRAIN"
                cp -a "$LAB_FILE_PATH" "$FEAT_EXTRACTION_VISUAL_LABELS_TRAIN"
                echo "COPIED -> $JPG_FOLDER_PATH -> TRAIN"
                echo "COPIED -> $LAB_FILE_PATH -> TRAIN"
            else
                cp -a "$JPG_FOLDER_PATH" "$FEAT_EXTRACTION_VISUAL_RECORDINGS_TEST"
                cp -a "$LAB_FILE_PATH" "$FEAT_EXTRACTION_VISUAL_LABELS_TEST"
                echo "COPIED -> $JPG_FOLDER_PATH -> TEST"
                echo "COPIED -> $LAB_FILE_PATH -> TEST"
            fi
            COUNT=$(($COUNT + 1))
        done
fi


# crop coord = 200:120:570:325
