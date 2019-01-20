# Logspout + Gelf

A Docker image with [Logspout](https://github.com/gliderlabs/logspout) and a [Gelf module](https://github.com/micahhausler/logspout-gelf)
based on the official Logspout Docker image.

## Setup

The `build.sh` script is copied from https://github.com/gliderlabs/logspout/blob/master/build.sh.
The `modules.go` script is copied from https://github.com/gliderlabs/logspout/blob/master/modules.go and modified
to include the gelf module.

## Building

```
docker build .
```
