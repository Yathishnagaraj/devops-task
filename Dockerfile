FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
ARG NODE_ENV=production
ENV NODE_ENV=$NODE_ENV
RUN npm install
COPY . .
EXPOSE 3050
CMD ["npm", "start"]
