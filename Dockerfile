# Base Image
FROM node:18-alpine

# App Directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy remaining files
COPY . .

# Expose port (agar server chalate ho to)
EXPOSE 3000

# Start app
CMD ["node", "index.js"]