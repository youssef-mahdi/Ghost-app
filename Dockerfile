FROM ubuntu as base
RUN apt update
RUN apt-get update && apt-get install -y nginx
RUN apt install -y curl
RUN apt install npm -y
RUN npm install --global n
RUN n 18
RUN npm install --global nx@latest -y
RUN npm install --global yarn --force -y

RUN rm /etc/nginx/sites-available/default
RUN rm /etc/nginx/sites-enabled/default

# Create a symbolic link to enable the new configuration

FROM base
WORKDIR /myapp
COPY . .
RUN mv ./reverse-proxy /etc/nginx/sites-enabled/reverse-proxy
RUN yarn setup
RUN chmod 777 ./entrypoint.sh
EXPOSE 8000
ENTRYPOINT [ "./entrypoint.sh" ]