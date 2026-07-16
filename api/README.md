# U-Skill Wiki - API

This directory contains the backend service for the U-Skill Wiki. The API is built using Python and FastAPI.

## Prerequisites

To run this application, you can either use Docker or run it locally using Python.

**Using Docker:**
- [Install Docker](https://docs.docker.com/get-docker/)

**Local Development:**
- Python 3.11 or higher

**Environment Variables:**
You MUST set the `USKILL_ADMIN_EMAIL` and `USKILL_ADMIN_PASSWORD` environment variables before launching the API. These are required to access the admin panel.

## Running the API

### Using Docker (Recommended)

1. Go to the root directory of the project (`cd ..`).
2. Build and run the API container using Docker Compose:
   ```bash
   docker-compose up --build api
   ```
The API will be available at http://localhost:8000.

### Local Development

If you prefer to run the API locally without Docker:

1. Create and activate a virtual environment:
   ```bash
   python -m venv .venv
   source .venv/bin/activate  # On Windows use: .venv\Scripts\activate
   ```

2. Install the dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Start the development server:
   ```bash
   uvicorn src.main:app --host 0.0.0.0 --port 8000 --reload
   ```

## Database Seeding

To populate the database with base data, you can use the provided seeder script located in the `seeder/` folder.

> [!WARNING]
> Running this seeder script will **overwrite the current database** if it already exists. All existing data will be lost.

From the `api/` directory, ensure your virtual environment is activated (if you are running locally), then run:

```bash
python seeder/seeder.py
```

---

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="../assets/images/Logotype_Nantes-U_blanc-72dpi.png" width="192px"/>
  <img alt="Nantes Université" src="../assets/images/Logotype_Nantes-U_noir-72dpi.png" width="192px"/>
</picture>
