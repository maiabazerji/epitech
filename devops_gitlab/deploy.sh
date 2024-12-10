#!/bin/sh

set -x

# Check if network exists
if [ "$(docker network ls -qf "name=zero")" ]; then
    echo "Network zero exists"
else
    echo "Network zero does not exist"
    docker network create zero
fi

# Run postgres container
cd database
if [ "$(docker ps -qf "name=postgres")" ]; then
    echo "Container postgres is running"
else
    echo "Container postgres is not running"
    docker build -f Dockerfile.zero -t postgres .
    docker run -d --network zero --name postgres -p 5432:5432 --env-file ../.env -v postgres_data:/var/lib/postgresql/data postgres
fi

# Run backend container
cd ../backend
if [ "$(docker ps -qf "name=backend1")" ]; then
    BACKEND=1
    docker build -f Dockerfile.zero -t backend2 .
    docker run -d --network zero --name backend2 -p 8081:8080 --env-file ../.env backend2
elif [ "$(docker ps -qf "name=backend2")" ]; then
    BACKEND=2
    docker build -f Dockerfile.zero -t backend1 .
    docker run -d --network zero --name backend1 -p 8080:8080 --env-file ../.env backend1
else
    BACKEND=0
    echo "Container backend 1 is not running"
    docker build -f Dockerfile.zero -t backend1 .
    docker run -d --network zero --name backend1 -p 8080:8080 --env-file ../.env backend1
fi


# Run nginx container
cd ../nginx
if [ "$(docker ps -qf "name=nginx")" ]; then
    echo "Container nginx is running"
else
    echo "Container nginx is not running"
    docker build -f Dockerfile.zero -t nginx .
    docker run -d --network zero --name nginx -p 80:80 nginx
fi

# Copy frontend build files to nginx container
CONTAINER_NAME="nginx"
CONTAINER_ID=$(docker ps -qf "name=${CONTAINER_NAME}")

HTML_1="/var/www/html1"
HTML_2="/var/www/html2"
FRONTEND_BUILD="../dist/."

# Check if index.html exists in the first file path
if docker exec "$CONTAINER_ID" ls "${HTML_1}/index.html" > /dev/null 2>&1; then
    docker cp "$FRONTEND_BUILD" "$CONTAINER_ID":"$HTML_2"
    docker cp ./default.2.zero.conf "$CONTAINER_ID":/etc/nginx/conf.d/default.conf
    docker exec "$CONTAINER_ID" nginx -s reload
    
# Check if index.html exists in the second file path
elif docker exec "$CONTAINER_ID" ls "${HTML_2}/index.html" > /dev/null 2>&1; then
    docker cp "$FRONTEND_BUILD" "$CONTAINER_ID":"$HTML_1"
    docker cp ./default.1.zero.conf "$CONTAINER_ID":/etc/nginx/conf.d/default.conf
    docker exec "$CONTAINER_ID" sh -c "rm -rf $HTML_2/*"
    docker exec "$CONTAINER_ID" nginx -s reload
    
# If neither condition is met, copy content to a fallback location
else
    docker cp "$FRONTEND_BUILD" "$CONTAINER_ID":"$HTML_1"
fi

# Stop the correct backend container based on the BACKEND variable
if [ "$BACKEND" -eq 1 ]; then
    docker stop backend1
    docker rm backend1
    docker exec "$CONTAINER_ID" sh -c "rm -rf $HTML_1/*"
elif [ "$BACKEND" -eq 2 ]; then
    docker stop backend2
    docker rm backend2
    docker exec "$CONTAINER_ID" sh -c "rm -rf $HTML_2/*"
else
    echo "Initial Run on Deployment Server"
fi
