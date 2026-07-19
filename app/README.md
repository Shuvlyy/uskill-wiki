# U-Skill Wiki - App

This directory contains the frontend application for the U-Skill Wiki. The application is built using Flutter and is compiled for the web.

## Prerequisites

To run this application, you can either use Docker or run it locally using the Flutter SDK.

**Using Docker:**
- [Install Docker](https://docs.docker.com/get-docker/)

**Local Development:**
- [Install Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel recommended)

## Running the App

### Using Docker (recommended)

The Dockerfile in this directory uses a multi-stage build to compile the Flutter web app and serve it using Nginx.

1. Go to the root directory of the project (`cd ..`).
2. Build and run the app container using Docker Compose:
   ```bash
   docker-compose up --build app
   ```
The application will be accessible at http://localhost:8080.

### Local Development

If you prefer to run the application locally without Docker:

1. Fetch the dependencies:
   ```bash
   flutter pub get
   ```

2. Generate necessary boilerplate files:
   ```bash
   dart run build_runner build
   ```

3. Run the application in Chrome:
   ```bash
   flutter run -d chrome
   ```

To build a release version for the web, you can run:
```bash
flutter build web --release
```

---

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="../assets/images/Logotype_Nantes-U_blanc-72dpi.png" width="192px"/>
  <img alt="Nantes Université" src="../assets/images/Logotype_Nantes-U_noir-72dpi.png" width="192px"/>
</picture>
