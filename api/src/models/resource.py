import enum
import uuid
from datetime import datetime

from sqlalchemy import JSON, Column, DateTime, Enum, String

from src.database import Base
from src.models.language_level import LanguageLevel
from src.models.learning_focus import LearningFocus


class ResourceType(str, enum.Enum):
    exercise = "exercise"
    game = "game"
    video = "video"
    article = "article"
    link = "link"


class ResourceStatus(str, enum.Enum):
    pending = "pending"
    approved = "approved"
    rejected = "rejected"


class Resource(Base):
    __tablename__ = "resources"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    title = Column(String, index=True, nullable=False)
    description = Column(String, nullable=False)
    content_url = Column(String, nullable=False)

    type = Column(Enum(ResourceType), nullable=False)
    language = Column(String, nullable=False)
    focus = Column(Enum(LearningFocus), nullable=False)
    level = Column(Enum(LanguageLevel), nullable=False)

    target_audiences = Column(JSON, nullable=False)
    tags = Column(JSON, nullable=False)

    author_name = Column(String, nullable=False)
    author_email = Column(String, nullable=False)

    created_at = Column(DateTime, default=datetime.now)
    status = Column(Enum(ResourceStatus), default=ResourceStatus.pending)
