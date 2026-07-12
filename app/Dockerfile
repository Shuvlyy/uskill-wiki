# flutter build
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

COPY pubspec.* ./
RUN flutter pub get

COPY . .
RUN flutter build web

# nginx stuff
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html

# go_router fix
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
