FROM ubuntu
WORKDIR /myapp
COPY . . 
RUN apt update
RUN apt-get update && apt-get install -y nginx
RUN apt install -y curl
RUN apt install npm -y
RUN npm install --global n
RUN n 18
RUN npm install --global nx@latest -y
RUN npm install --global yarn --force -y
RUN yarn setup
RUN rm /etc/nginx/sites-available/default
RUN rm /etc/nginx/sites-enabled/default

# Create a new Nginx configuration file for the reverse proxy
RUN echo 'server {' > /etc/nginx/sites-available/reverse-proxy
RUN echo '    listen 8000;' >> /etc/nginx/sites-available/reverse-proxy
RUN echo '    location / {' >> /etc/nginx/sites-available/reverse-proxy
RUN echo '        proxy_pass http://localhost:2368$request_uri;' >> /etc/nginx/sites-available/reverse-proxy
RUN echo '        proxy_set_header Host $host;' >> /etc/nginx/sites-available/reverse-proxy
RUN echo '        proxy_set_header X-Real-IP $remote_addr;' >> /etc/nginx/sites-available/reverse-proxy
RUN echo '    }' >> /etc/nginx/sites-available/reverse-proxy
RUN echo '}' >> /etc/nginx/sites-available/reverse-proxy


# Create a symbolic link to enable the new configuration
RUN ln -s /etc/nginx/sites-available/reverse-proxy /etc/nginx/sites-enabled/
RUN chmod 777 ./entrypoint.sh
# Expose port 8000 for incoming traffic
EXPOSE 8000
ENTRYPOINT [ "./entrypoint.sh" ]
