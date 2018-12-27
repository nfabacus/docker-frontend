# Docker app

### Dockerfile for development
As we name Dockerfile.dev for development, we need to specify the file name when building it.
```docker build -f Dockerfile.dev . ```

-v /app/node_modules below adds a bookmark not to override the node_modules.</br>
-v "$(pwd):/app below maps all the files except for the bookmarked node_modules </br>
```docker run -p 3000:3000 -v /app/node_modules -v "$(pwd):/app"  <image_name>``` </br>

**** I cannot get volume mapping to work...But, Do I really need docker for local development?? ****

### Dockerfile for production
```
# Builder Phase
FROM node:alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# Run Phase
FROM nginx
COPY --from=builder /app/build /usr/share/nginx/html

```

This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).