# flutter build
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

COPY pubspec.* ./
RUN flutter pub get

COPY . .
ARG API_URL=http://127.0.0.1:8000
RUN dart run build_runner build
RUN flutter build web --dart-define=API_URL=$API_URL

# nginx stuff
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html

# go_router fix
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
