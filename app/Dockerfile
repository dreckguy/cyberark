FROM node:14.8
WORKDIR /usr/src/app/

COPY . .
ENV DB_URL='http://host.docker.internal:8529'

RUN npm install 
EXPOSE 4000
#CMD "node init.js"
CMD ["node","server.js"]
