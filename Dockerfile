FROM node:14-slim
WORKDIR /usr/src/app
COPY ./package*.json ./
RUN npm intsall
COPY . .
USER node
CMD ["npm", "start"]