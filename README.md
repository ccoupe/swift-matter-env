ccoupe@nopi:~/swift-matter-env$ docker build . --tag swift-matter-env  

docker run -it --cpus 4 --memory 8G -v .:/code:z swift-matter-env
