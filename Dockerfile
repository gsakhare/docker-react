FROM node:alpine as builder 
WORKDIR '/app'
COPY package.json ./
RUN npm install
COPY . .
RUN npm run build 

# FROM nginx
# # This is for aws bean stalk
# EXPOSE 80 
# COPY --from=builder /app/build /usr/share/nginx/html

#Create a new container from a linux base image that has the aws-cli installed
FROM mesosphere/aws-cli

#Using the alias defined for the first container, copy the contents of the build folder to this container
COPY --from=builder /app/build .

#Set the default command of this container to push the files from the working directory of this container to our s3 bucket 
CMD ["s3", "sync", "./", "s3://elasticbeanstalk-us-east-2-387642852659"] 