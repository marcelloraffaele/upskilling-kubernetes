# Stage 1: Build
FROM node:lts AS builder
WORKDIR /usr/src/app
# Copy package files and install dependencies
COPY package*.json ./
RUN npm install --omit=dev

# Stage 2: Production
FROM node:lts-slim AS production
WORKDIR /usr/src/app
# Copy only the installed dependencies and app files from the builder stage
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY . .
# Run as non-root user for security
USER node
# The default command to run when starting the container
CMD [ "npm", "start" ]