# Use the official Node.js 18 image
FROM node:18

# Install dependencies including Chromium
RUN apt-get update && \
    apt-get install -y \
    chromium \
    libnss3 \
    libgbm-dev \
    libxkbcommon0 \
    fonts-liberation \
    libappindicator3-1 \
    wget \
    gnupg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set environment variable for Chromium path
ENV CHROME_PATH=/usr/bin/chromium

# Verify Chromium installation
RUN chromium --version

# Create and change to the app directory
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
COPY package*.json ./

# Install production dependencies.
RUN npm install --only=production

# Install Puppeteer
RUN npm install puppeteer

# Copy local code to the container image.
COPY . .

# Expose the port the app runs on
EXPOSE 3000

# Run the web service on container startup.
CMD ["node", "dexscreener.js"]
