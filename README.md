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

You can also use TLS, which you should use for security if passing messages across an insecure network like the public internet. See below.

See https://github.com/gliderlabs/logspout for more running information.

See https://github.com/micahhausler/logspout-gelf for information about how Docker information is turned into GELF parameters.

## TLS

### Self-signed certificates

#### Server certificate

Create an openssl config file `server.cnf` with contents as below, editing the contents of the `[dn]` and `[alt_names]` sections:

```
[req]
default_bits = 4096
prompt = no
default_md = sha256
x509_extensions = v3_req
distinguished_name = dn

[dn]
C = US
ST = CA
L = San Francisco
O = Example Organisation
CN = example.com

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = example.com
DNS.2 = *.example.com
IP.1 = 10.1.1.1
```

Then generate your self-signed certificate:

```
openssl req -new -x509 -config server.cnf -nodes -keyout server-key.pem -out server-cert.pem -days 35600
```

You can view the contents of the certificate:

```
openssl x509 -in server-cert.pem -noout -text
```

#### Client certificate

Create a new directory named `clients` so that all of the client certificates that you generate are in one directory.
This helps when configuring Graylog as you can give it a directory of client certificates to trust.

Create an openssl config file `<clientname>.cnf` with contents as below, editing the contents of the `[dn]` and `[alt_names]` sections:

```
[req]
default_bits = 4096
prompt = no
default_md = sha256
x509_extensions = v3_req
distinguished_name = dn

[dn]
C = US
ST = CA
L = San Francisco
O = Example Organisation
CN = client.example.com

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = client.example.com
DNS.2 = 10.1.1.2
```

Then generate your self-signed certificate:

```
openssl req -new -x509 -config <clientname>.cnf -nodes -keyout <clientname>-key.pem -out <clientname>-cert.pem -days 35600
```

You can view the contents of the certificate:

```
openssl x509 -in <clientname>-cert.pem -noout -text
```

### Running

See https://github.com/gliderlabs/logspout#tls-settings for the environment variables to use to configure the `tls` transport.

An example mounting the server certificate into the logspout container and setting the `LOGSPOUT_TLS_CA_CERTS` environment variable to reference it.
Make sure you only have the server certificate and not its primary key on any clients!

```
docker run \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /opt/logspout-gelf:/opt/logspout-gelf \
    -e LOGSPOUT_TLS_CA_CERTS=/opt/logspout-gelf/server-cert.pem \
    karlvr/logspout-gelf:latest \
    gelf+tls://<graylog_host>:12201
```

Another example showing client authentication. You need the server certificate and the client's certificate and private key.

```
docker run \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /opt/logspout-gelf:/tls \
    -e LOGSPOUT_TLS_CA_CERTS=/tls/server-cert.pem \
    -e LOGSPOUT_TLS_CLIENT_CERT=/tls/client-cert.pem \
    -e LOGSPOUT_TLS_CLIENT_KEY=/tls/client-key.pem \
    karlvr/logspout-gelf:latest \
    gelf+tls://<graylog_host>:12201
```

## Publishing

```shell
docker build . -t karlvr/logspout-gelf
docker push karlvr/logspout-gelf
```
