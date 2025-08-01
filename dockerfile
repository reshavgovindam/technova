# Use official Node.js base image
FROM node:18

# Set app directory
WORKDIR /app

# Copy dependencies
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all other files
COPY . .

# Expose the port
EXPOSE 3000

# Start the app
CMD ["node", "index.js"]
