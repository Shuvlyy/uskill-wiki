# U-Skill Wiki

This application is a wiki of resources designed for students at Nantes Université.

This repository is divided into two main components:
- `api`: The backend service built with Python and FastAPI.
- `app`: The frontend user interface built with Flutter.

## Getting Started (Quick Setup)

If you are not familiar with development tools or want an automated installation process, please refer to the dedicated setup guides depending on your operating system:

- **[macOS Setup Guide](memo_setup_macOS.md)**
- **[Windows Setup Guide](memo_setup_Windows.md)**

These guides will help you install and run the project from scratch without any prior technical knowledge!

## Prerequisites

To run this application, it is recommended to use Docker.

- [Install Docker](https://docs.docker.com/get-docker/)
- [Install Docker Compose](https://docs.docker.com/compose/install/)

## Configuration

Before running the application, you need to configure your environment variables.
Copy the `.env.sample` file to a new file named `.env` and fill it up according to what's in `.env.sample` but with **YOUR data**!!

```bash
cp .env.sample .env
```

Here is what each variable serves for:
- `USKILL_ADMIN_EMAIL`: Email address to access the admin panel in the app.
- `USKILL_ADMIN_PASSWORD`: Password to access the admin panel in the app.
- `API_PORT`: Host port exposed for the API backend (default `8000`).
- `APP_PORT`: Host port exposed for the App frontend (default `8080`).
- `API_URL`: The base URL used by the app to reach the API (e.g., `http://127.0.0.1:8000`).

## Running the Application

The easiest way to start the complete application (both backend and frontend) is by using Docker Compose.

1. Clone the repository:
   ```bash
   git clone git@github.com:Shuvlyy/uskill-wiki.git
   cd uskill-wiki
   ```

2. Build and start the containers:
   ```bash
   docker-compose up --build
   ```

3. Access the application:
   - Frontend App: http://localhost:8080
   - Backend API: http://localhost:8000

To stop the application, run:
```bash
docker-compose down
```

For more detailed information on running the individual components locally, please refer to the specific README files in the `api` and `app` directories.

---

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="assets/images/Logotype_Nantes-U_blanc-72dpi.png" width="192px"/>
  <img alt="Nantes Université" src="assets/images/Logotype_Nantes-U_noir-72dpi.png" width="192px"/>
</picture>
