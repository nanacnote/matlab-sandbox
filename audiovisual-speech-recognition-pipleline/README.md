## Python | Octave | FFMPEG | HTK

A dockerised workflow for running Matlab scripts with Octave. FFMPEG and HTK are also install in the container.

### Notes

- `./work` is mapped to the container as a volume
- `./work/data` contains training and testing data

### Setup

```
git clone
make build
```

### Run

```
make serve
```
