FROM node:12-alpine as build

# Install build dependencies for native modules (grpc)
RUN apk add --no-cache python3 make g++ python3-dev

WORKDIR /usr/local/api-gateway

COPY dist package.json ./

RUN npm install --production

FROM node:12-alpine

WORKDIR /usr/local/api-gateway

COPY --from=build /usr/local/api-gateway .

EXPOSE 3000

CMD ["node", "main.js"]
