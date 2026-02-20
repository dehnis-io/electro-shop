FROM nginx:alpine 

ENV Electro_shop_env=Dev

LABEL maintainer="tech.advocate247@gmail.com" 
LABEL version="0.1" 

#Remove default nginx website 
RUN rm -rf /usr/share/nginx/html/* 

#Copy your static website files to Nginx’s web root 
COPY . /usr/share/nginx/html 

# Expose port 80
EXPOSE 80

# Start Nginx in the foreground so the container stays running
CMD ["nginx", "-g", "daemon off;"]