import os
from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

os.makedirs("./data", exist_ok=True)

SQLALCHEMY_DATABASE_URL = "sqlite:///./data/uskill.db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)  # todo: remove connect_args when upgrading to postgre

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()
