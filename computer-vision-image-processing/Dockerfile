FROM jupyter/base-notebook

LABEL Description="Jupyter Octave"

USER root

RUN apt update && apt install -y \
    gcc-multilib \
    git \
    yasm \
    build-essential \
    gnuplot \
    ffmpeg \
    octave \
    liboctave-dev \
    octave-control \
    octave-signal \
    octave-image \
    octave-video \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/archive/* /var/lib/apt/lists/*

USER jovyan

# create octave config file
RUN printf " \
pkg load control\n \
pkg load signal\n \
pkg load image\n \
pkg load video\n" \
    >>~/.octaverc

RUN pip install octave_kernel && \
    export OCTAVE_EXECUTABLE=$(which octave)