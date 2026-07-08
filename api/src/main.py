import fastapi

from src.database import Base, engine
from src.routers import resources

Base.metadata.create_all(bind=engine)

app = fastapi.FastAPI(
    title="U-Skill Wiki API",
    description="",
    version="0.0.1",
)

app.include_router(resources.router)


@app.get("/ping")
async def pong():
    return {
        "status": "success",
        "message": "pong lol",
    }
