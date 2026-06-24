import fastapi

app = fastapi.FastAPI(
    title="U-Skill Wiki API",
    description="",
    version="0.0.1",
)


@app.get("/ping")
async def pong():
    return {
        "status": "success",
        "message": "pong lol",
    }
