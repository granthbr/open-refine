#### Open Refine and Virtuoso Docker image

first, create an external volume:
docker volume create --name or-data

start docker-compose
docker-compose up

this will build the container and start it. Port 3333 will be exposed

To access openrefine, http://0.0.0.0:3333



