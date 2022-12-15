FROM jupyter/base-notebook

LABEL Description="Jupyter Octave HTK ffmpeg"

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

# # build libav from source code
# RUN git clone git://git.libav.org/libav.git /libav && \
#     cd /libav && \
#     ./configure && \
#     make && \
#     make install && \
#     rm -rf /libav

# build HTK from modified source code
RUN git clone -b r3.4.1_fix https://github.com/davegreenwood/HTK.git /htk && \
    cd /htk && \
    ./configure --prefix=/ --disable-hslab &&\
    make all && \
    make install && \
    rm -rf /htk

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