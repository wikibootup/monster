FROM node:16-buster-slim AS builder

RUN apt update

WORKDIR /app

COPY package.json ./
COPY yarn.lock ./

RUN yarn install

COPY docusaurus.config.js ./
COPY babel.config.js ./
COPY sidebars.js ./
COPY docs/ ./docs/
COPY src/ ./src/
COPY static/ ./static/

RUN yarn run build

FROM nginx:1.21.1

RUN rm -rf /etc/nginx/conf.d
COPY ./.docker/monster/nginx/conf /etc/nginx

COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 3000

CMD [ "nginx", "-g", "daemon off;" ]
