# Logspout + GELF

A Docker image with [Logspout](https://github.com/gliderlabs/logspout) and a [GELF module](https://github.com/karlvr/logspout-gelf)
based on the official Logspout Docker image.

The GELF module supports UDP and TCP transports. The default transport is UDP.

## Setup

The `build.sh` script is copied from https://github.com/gliderlabs/logspout/blob/master/custom/build.sh.

The `modules.go` script is copied from https://github.com/gliderlabs/logspout/blob/master/modules.go and modified
to include the GELF module.

## Building

```
docker build .
```

## Running

Run using UDP:

```
docker run \
    -v /var/run/docker.sock:/var/run/docker.sock \
    karlvr/logspout-gelf:latest \
    gelf://<graylog_host>:12201
```

Run using TCP:

```
docker run \
    -v /var/run/docker.sock:/var/run/docker.sock \
    karlvr/logspout-gelf:latest \
    gelf+tcp://<graylog_host>:12201
```

See https://github.com/gliderlabs/logspout for more running information.

See https://github.com/micahhausler/logspout-gelf for information about how Docker information is turned into GELF parameters.
