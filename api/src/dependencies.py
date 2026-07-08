from fastapi import Header, HTTPException

from src.database import SessionLocal


def get_db():
    """
    Creates a fresh database session for each request and automatically
    closes it when the request is finished, preventing memory leaks.
    """
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

