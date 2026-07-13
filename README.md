# U-Skill Wiki

This application is a wiki of resources designed for students at Nantes Université.

This repository is divided into two main components:
- `api`: The backend service built with Python and FastAPI.
- `app`: The frontend user interface built with Flutter.

## Prerequisites

To run this application, it is recommended to use Docker.

- [Install Docker](https://docs.docker.com/get-docker/)
- [Install Docker Compose](https://docs.docker.com/compose/install/)

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
