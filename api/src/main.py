import fastapi
from fastapi.middleware.cors import CORSMiddleware

from src.database import Base, engine
from src.routers import resources

Base.metadata.create_all(bind=engine)  # todo: use alembic for production

app = fastapi.FastAPI(
    title="U-Skill Wiki API",
    description="",
    version="0.0.1",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "*"
    ],  # todo: !!! not for production. should be something like "allow_origins=["https://u-skill.univ-nantes.fr"]"
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(resources.router)


@app.get("/ping")
async def pong():
    return {
        "status": "success",
        "message": "pong lol",
    }
