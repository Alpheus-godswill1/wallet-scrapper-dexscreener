# Use the official Node.js 18 image
FROM node:18

# Install dependencies including Xvfb and necessary libraries
RUN apt-get update && \
    apt-get install -y \
    xvfb \
    wget \
    gnupg \
    libnss3 \
    libgbm-dev \
    libxkbcommon0 \
    fonts-liberation \
    libappindicator3-1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Playwright and browsers
RUN npm install -g playwright && \
    playwright install

# Create and change to the app directory
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image
COPY package*.json ./

# Install production dependencies
RUN npm install --only=production

# Copy local code to the container image
COPY . .

# Expose the port the app runs on
EXPOSE 3000

# Health check to ensure the app is running
HEALTHCHECK CMD curl --fail http://localhost:3000 || exit 1

# Run the web service on container startup
CMD ["node", "dexscreener.js"]
