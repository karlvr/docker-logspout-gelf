# Logspout + GELF

A Docker image with [Logspout](https://github.com/gliderlabs/logspout) and a [GELF module](https://github.com/micahhausler/logspout-gelf)
based on the official Logspout Docker image.

## Setup

The `build.sh` script is copied from https://github.com/gliderlabs/logspout/blob/master/build.sh. A command to fetch the source
for the GELF module is added.

The `modules.go` script is copied from https://github.com/gliderlabs/logspout/blob/master/modules.go and modified
to include the gelf module.

## Building

```
docker build .
```

## Running

```
docker run \
    -v /var/run/docker.sock:/var/run/docker.sock \
    karlvr/logspout-gelf:latest \
    gelf://<graylog_host>:12201
```

See https://github.com/gliderlabs/logspout for more running information.

See https://github.com/micahhausler/logspout-gelf for information about how Docker information is turned into GELF parameters.
