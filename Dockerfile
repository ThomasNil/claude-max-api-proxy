FROM node:22-bookworm

WORKDIR /app

RUN npm install -g @anthropic-ai/claude-code

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

EXPOSE 3456

CMD ["npm", "start"]
