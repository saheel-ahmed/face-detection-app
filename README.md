# face-detection-app
Face Detection App

# Docker Useful commands
docker login

docker images

docker ps -a

docker rm <container_id>

docker rmi <image_id>

docker build -t face-detection-app .

docker run -it -p 3223:3223 face-detection-app

docker run -p 3223:3223 face-detection-app

docker logs 94bec2911629

docker start -i 94bec2911629
