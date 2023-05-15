FROM node:lts-hydrogen AS build-env

WORKDIR /App

COPY package*.json ./
RUN npm ci
COPY . ./

RUN npm run build

FROM node:lts-alpine
WORKDIR /App

COPY --from=build-env /App/.svelte-kit .svelte-kit/
COPY --from=build-env /App/node_modules node_modules/
COPY package.json .
COPY vite.config.js .
COPY .env .

EXPOSE 5000
ENV NODE_ENV=production

CMD [ "npm", "run", "preview" ]
