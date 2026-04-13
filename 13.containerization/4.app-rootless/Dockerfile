FROM node:18-alpine

# Create a dedicated non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app
COPY --chown=appuser:appgroup . .
RUN npm ci --only=production

# Switch to non-root user
USER appuser

EXPOSE 3000
CMD ["node", "server.js"]