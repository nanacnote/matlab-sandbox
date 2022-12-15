#!/bin/bash

EXP_FOLDERS="experiments/withSum"
PROTO_STATES="proto4State proto8State proto16State"

Gram2net() {
        for expFolder in ${EXP_FOLDERS}; do
                echo "\n"
                echo "Network files generated for ${expFolder}"
                HParse "$expFolder"/lib/GRAM "$expFolder"/lib/NET 
        done
}

if [ "$1" = "reset" ]; then
        find . -name ".DS_Store" -type f -print0 | xargs -0 rm
        rm -rf experiments
        for expFolder in ${EXP_FOLDERS}; do
                mkdir -p $expFolder
                mkdir "$expFolder"/hmms
                mkdir "$expFolder"/lib
                mkdir "$expFolder"/list
                mkdir "$expFolder"/list/test
                mkdir "$expFolder"/list/train
                mkdir "$expFolder"/list/named_test
                mkdir "$expFolder"/results
                mkdir "$expFolder"/vectors
                mkdir "$expFolder"/vectors/test
                mkdir "$expFolder"/vectors/train
                mkdir "$expFolder"/vectors/named_test
        done
        echo "All previous experiments removed!"
fi

if [ "$1" = "train" ]; then
        octave-cli script.m "$1" && 
        Gram2net &&
        for protoState in ${PROTO_STATES}; do
                for expFolder in ${EXP_FOLDERS}; do
                        echo "\n\n"
                        rm -rf "$expFolder"/hmms/"$protoState" && mkdir "$expFolder"/hmms/"$protoState"
                        cat "$expFolder"/lib/words | while read _word_
                        do
                                HInit -S "$expFolder"/list/train/trainList -l "$_word_" -L labels/train -M "$expFolder"/hmms/"$protoState" -o "$_word_" -T 1 "$expFolder"/lib/"$protoState".txt
                        done
                done
        done
fi

if [ "$1" = "test" ]; then
        octave-cli script.m "$1" &&
        Gram2net &&
        for protoState in ${PROTO_STATES}; do
                for expFolder in ${EXP_FOLDERS}; do
                        echo "\n\n"
                        rm -rf "$expFolder"/results/"$protoState" && mkdir "$expFolder"/results/"$protoState"
                        HVite -T 1 -S "$expFolder"/list/test/testList -d "$expFolder"/hmms/"$protoState" -w "$expFolder"/lib/NET -l "$expFolder"/results/"$protoState" "$expFolder"/lib/dict "$expFolder"/lib/words
                done
        done
fi

if [ "$1" = "result" ] && [ "$2" ]; then
        for protoState in ${PROTO_STATES}; do
                echo "\n\n"
                HResults -p -e "???" sil -L labels/test experiments/"$2"/lib/words experiments/"$2"/results/"$protoState"/*.rec
        done
fi

# HResults -p -e "???" sil -L labels/test experiments/withLinFil/lib/words experiments/withLinFil/results/proto2State/*.rec

# HVite -T 1 -d experiments/withTriMelFil/hmms/proto16State -w experiments/withTriMelFil/lib/NET experiments/withTriMelFil/lib/dict experiments/withTriMelFil/lib/words experiments/withTriMelFil/vectors/named_test/speech_1
