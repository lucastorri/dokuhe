

## Run Using Docker

```bash
./docker-build-all.sh

docker run -it -e LANG=en -p 9000:9000 page-service

docker run -it -e SALUTATION=Dear -p 8000:8000 hello-service

docker run -it -e HELLO_SERVICE_URL=http://192.168.108.93:8000 -e PAGES_SERVICE_URL=http://192.168.108.93:9000 -p 7000:7000 hello-page-service
```
