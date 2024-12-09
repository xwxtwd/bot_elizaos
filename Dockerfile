# Use a specific Node.js version for better reproducibility
FROM node:23.3.0-slim

# Install pnpm globally and install necessary build tools
RUN npm install -g pnpm@9.4.0 && \
    apt-get update && \
    apt-get install -y git python3 make g++ && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set Python 3 as the default python
RUN ln -s /usr/bin/python3 /usr/bin/python

# Set the working directory
WORKDIR /app

# Copy package.json and other configuration files
COPY package.json pnpm-lock.yaml ./

# Install dependencies and build the project
RUN pnpm install

# Copy the rest of the application code
COPY src ./src
COPY characters ./characters
COPY tsconfig.json ./

ENV NODE_OPTIONS="--max-old-space-size=8192"
CMD ["pnpm", "run", "start", "--characters='./characters/elizaos.character.json'"]
