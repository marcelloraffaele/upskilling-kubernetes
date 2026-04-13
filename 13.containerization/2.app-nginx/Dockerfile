FROM nginx:alpine

# Remove the default nginx welcome page
RUN rm -rf /usr/share/nginx/html/*

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the application files
COPY html/ /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Nginx starts automatically as the default CMD in the base image
