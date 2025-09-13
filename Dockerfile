FROM node:18-alpine

WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .
ENV PORT=3050
EXPOSE 3050
CMD ["npm", "start"]
