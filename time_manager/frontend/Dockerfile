# Use the official Node.js image for building the Vue.js app
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

COPY . . 

RUN npm install 

RUN npm run build

EXPOSE 8080

CMD [ "npm", "run", "serve" ]
