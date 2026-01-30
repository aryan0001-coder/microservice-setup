FROM node:12-alpine as build

# Install build dependencies for native modules (grpc, pg-native)
RUN apk add --no-cache python3 make g++ python3-dev

WORKDIR /usr/local/organizations-svc

COPY dist package.json ./

RUN npm install --production

FROM node:12-alpine

WORKDIR /usr/local/organizations-svc

COPY --from=build /usr/local/organizations-svc .

EXPOSE 50051

CMD ["node", "main.js"]
