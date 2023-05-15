FROM node:lts-hydrogen AS build-env

WORKDIR /App

COPY package*.json ./
RUN npm ci
COPY . ./

# PUBLIC_STATIC_MESSAGE=This message was set at build-time in Dockerfile
# PUBLIC_DYNAMIC_MESSAGE=This message was set at build-time in Dockerfile

RUN npm run build
# May need to RUN npm prune --production

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
