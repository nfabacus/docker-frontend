# Docker app

### Dockerfile for development
As we name Dockerfile.dev for development, we need to specify the file name when building it.
```docker build -f Dockerfile.dev . ```

#### Docker Volumes ```-v``` or ```--volume```
-v /app/node_modules - this does not have ```:<copy destination>``` so, it is a bookmark not to override the node_modules, meaning do not reference/map to anything.</br>
-v "$(pwd):/app below maps all the files except for the bookmarked node_modules </br>
```docker run -p 3000:3000 -v /app/node_modules -v $(pwd):/app <image_name>``` </br>

**** I cannot get volume mapping to work...But, Do I really need docker for local development?? ****

### Dockerfile for production
```
# Builder Phase
FROM node:alpine as builder   # Define everything FROM <base image> as builder phase (till next FRM)
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# Run Phase
FROM nginx
COPY --from=builder /app/build /usr/share/nginx/html   # This means copy from builder phase's build folder to nginx's html folder.
```
To run:
```
docker build .
```
then,
```
docker run -p 8080:80 <your image id>     #80 is the default port used by nginx.
```
Then, you can access it by visiting localhost:8080 on your browser.

This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).