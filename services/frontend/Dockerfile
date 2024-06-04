# Use a base image of Node.js
FROM node:14

# Set the working directory to /usr/src/app
WORKDIR /usr/src/app

# Copy the project files to the container
COPY . .

# Install project dependencies
RUN npm install

# Expose the port defined by the environment variable
EXPOSE $PORT

# Command to run the application
CMD ["node", "index.js"]