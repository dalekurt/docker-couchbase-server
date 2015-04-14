# Docker Couchbase Server

Builds a docker image for Couchbase. This Dockerfile and supporting scripts for running [Couchbase Server](http://couchbase.com/) in a Docker container.

## Summary

Repository name in Docker Hub: [dalekurt/couchbase](https://hub.docker.com/u/dalekurt/couchbase)

This repository contains Dockerized ZooKeeper, published to the public Docker Hub via automated build.

## Usage
```docker run -d -p 11210:11210 -p 11211:11211 -p 8091:8091 -p 8092:8092 --name couchbase dalekurt/couchbase```

## Build

```docker build -t dalekurt/couchbase .```

