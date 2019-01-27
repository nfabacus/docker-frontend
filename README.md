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

### Setup Travis
1. track your repo in travis website.
2. write .travis.yml
3. Next time when you push to the remote origin, travis will run the instruction in .travis.yml

### Setup AWS Elastic Beanstalk and Production Deployment
1. Go to AWS console and to Elastic Beanstalk
2. Click Create New Application and create one
3. Select web server environment
4. Go to Base configuration and select Docker for Platform.
5. Click Create environment
6. update .travis.yml file for deploy
7. Go to IAM section in AWS
8. Add user, then select Programmatic access for Access type (for travis to access)
9. For set permissions page, select 'Aattach existing policies directly'
10. Seach for AWSElasticBeanstalk for full access, and select it. Click next, and click review, then click Create User.
11. Set environmental variables for AWS user credentials.
  1) Go to travis CI site.
  2) Go to your project.
  3) Go to more options
  4) Go to settings, set the AWS_ACCESS_KEY and AWS_SECRET_KEY
12. Go back to .travis.yml file, and set the env variables.
13. To see, if it actually deploys, commit and push to the master.
14. Go back to Travis CI and AWS Beanstalk to see the progress/status.

Dockerfile
```
# Builder Phase
FROM node:alpine as builder
WORKDIR '/app'
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Run Phase
FROM nginx
EXPOSE 80  # Elasticbeanstalk will map this to its port automatically.
COPY --from=builder /app/build /usr/share/nginx/html


```


.travis.yml
```
sudo: required # super user permission
services:
  - docker # travis, we need a copy of docker running

before_install:
  - docker build -t nfabacus/docker-frontend -f Dockerfile.dev .
  # use current directory (.) to build docker image. tag the image with '-t nfabacus/docker-frontend'

script:
  - docker run nfabacus/docker-frontend npm run test -- --coverage # with coverage test will exit once complete.

deploy:
  provider: elasticbeanstalk  # deployment service provider
  region: eu-west-2  #specify the region the elasticbeanstalk instance was created.
  app: "docker-frontend"  # app name in elesticbeanstalk
  env: "DockerFrontend-env"  # get the env name from the elasticbeanstalk
  bucket_name: "elasticbeanstalk-eu-west-2-689483565571" # Get this from S3 Bucket in the AWS console.
  bucket_path: "docker-frontend" # app name in elesticbeanstalk will be the path for the bucket.
  on:
    branch: master  # deploy the app only when the code is pushed to the master branch
  access_key_id: $AWS_ACCESS_KEY
  secret_access_key:
    secure: "$AWS_SECRET_KEY"


```









This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).
