FROM ubuntu
WORKDIR /myapp
COPY . . 
RUN apt update
RUN apt install -y curl
RUN apt install npm -y
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
RUN nvm install 18
RUN nvm use 18 
RUN npm install --global nx@latest -y
RUN npm install --global yarn --force -y
RUN yarn build
RUN yarn dev
