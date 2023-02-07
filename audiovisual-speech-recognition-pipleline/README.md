## Python | Octave | FFMPEG | HTK

A dockerised workflow for running Matlab scripts with Octave.

### Notes

- `./work` is mapped to the container as a volume
- `./work/data` contains training and testing data
- create a dir `./work/data/raw` and drop `mp4` files for training and testing
- create a dir `./work/data/labs` and drop `.lab` files (i.e. text file with nanosecond labeling corresponding to mp4 files) use same file names as mp4

### Setup

```
git clone ...
make build
```

### Run

```
make serve
```

### lunch

```
http://localhost:8888
```
