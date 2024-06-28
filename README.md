### BUILD IMAGE
```
mdkir ~/swift-matter-env
cd ~/swift-matter-env
docker build . --tag swift-matter-env  
```

### USING IMAGE
  In one terminal run the esp_ref2217 server, replace the /dev/ttyUSBxx with yours. If port 4000 is already used for a different purpose you'll have to change the Dockerfile (down at the end) for different port.

`esp_rfc2217_server.py -v -p 4000 /dev/ttyUSB0` 

In a second terminal: cd to the directory you want to use from the container

`cd ~/swift-matter-examples`

Then run the following:  

`docker run -it --rm --cpus 4 --memory 8G --name swift-matter-env -v .:/code:z swift-matter-env`

You should be in the container now. The prompt will be devuser@1234897 or similar. `whoami` will be 'devuser' with a uid of 1000 and a gid of 1000. Those can be changed in the Dockerfile and then rebuild the image. You can use sudo without getting a password prompt.
