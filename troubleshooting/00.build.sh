# docker build -f Dockerfile-52 -t javalove93/hello .
# docker push javalove93/hello

# docker build -f Dockerfile-53 -t javalove93/hello-http-server .
# docker push javalove93/hello-http-server

docker build -f Dockerfile-54 -t javalove93/flask-hello-world .
docker push javalove93/flask-hello-world

# gcc -static -o hello_world src/hello_world.c
# docker build -f Dockerfile-57 -t javalove93/hello-without-shell .
# docker push javalove93/hello-without-shell
