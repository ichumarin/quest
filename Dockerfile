FROM node:10

# Create app directory
WORKDIR /usr/src/quest

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY . .
ENV SECRET_WORD="TwelveFactor"
EXPOSE 3000
CMD [ "node", "src/000.js" ]