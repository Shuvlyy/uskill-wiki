import os
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


def verify_admin(x_admin_email: str = Header(...), x_admin_password: str = Header(...)):
    """
    Checks if the request includes the correct admin credentials in the headers.
    If not, it instantly rejects the request with a 403 Forbidden error.
    """
    expected_email = os.environ.get("USKILL_ADMIN_EMAIL")
    expected_password = os.environ.get("USKILL_ADMIN_PASSWORD")

    if not expected_email or not expected_password:
        raise HTTPException(status_code=500, detail="Admin credentials are not configured on the server")

    if x_admin_email != expected_email or x_admin_password != expected_password:
        raise HTTPException(status_code=403, detail="Not authorized as Admin")
