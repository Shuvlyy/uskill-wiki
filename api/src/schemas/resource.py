from datetime import datetime
from typing import List, Set

from pydantic import BaseModel

from src.models.language_level import LanguageLevel
from src.models.resource import LearningFocus, ResourceStatus, ResourceType
from src.models.user_role import UserRole
from src.schemas.author import Author


class ResourceBase(BaseModel):
    title: str
    description: str
    content_url: str

    type: ResourceType
    language: str
    focus: LearningFocus
    level: LanguageLevel

    target_audiences: Set[UserRole]
    tags: List[str]

    author: Author


class ResourceCreate(ResourceBase):
    pass


class ResourceResponse(ResourceBase):
    id: str
    created_at: datetime
    status: ResourceStatus

    class Config:
        from_attributes = True
