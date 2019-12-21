## Introduction
A docker nginx included consul template

## How to run
### 1. Setup consul server
If you are using Docker Toolbox, you can get the IP address of your docker-machine (default here) by running
```
docker-machine ip default
192.168.99.100
```
If you are using Docker for Mac, the IP address you need to use is 172.17.0.1
Export this IP into an environment variable HOST_IP by running export HOST_IP=192.168.99.100 OR export HOST_IP=172.17.0.1 (used by docker-compose.yml below)

```
export HOST_IP=172.17.0.1
docker network create consul
docker-compose up
```

### 2. Start your service
For example, go into examples
```
docker-compose up
```
And visit `http://localhost`
Notes: make sure your service join into network `consul`