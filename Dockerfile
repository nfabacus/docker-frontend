# Builder Phase
FROM node:alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# Run Phase
FROM nginx
EXPOSE 80  # Elasticbeanstalk will map this to its port automatically.
COPY --from=builder /app/build /usr/share/nginx/html

