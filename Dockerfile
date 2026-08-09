FROM node:24-alpine
WORKDIR /app
COPY app/package.json ./
RUN npm install --omit=dev
COPY app/server.js ./
USER node
CMD ["node", "server.js"]
