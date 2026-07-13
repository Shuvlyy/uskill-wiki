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


def verify_admin(x_admin_token: str = Header(...)):
    """
    Checks if the request includes the correct admin token in the headers.
    If not, it instantly rejects the request with a 403 Forbidden error.
    """
    # todo: do jwt or ANYTHING more secure but this is for demo.
    if x_admin_token != "demo":
        raise HTTPException(status_code=403, detail="Not authorized as Admin")
