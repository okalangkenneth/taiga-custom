FROM nginx:alpine

# Copy nginx configuration into the container
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Command to run
CMD ["nginx", "-g", "daemon off;"]
