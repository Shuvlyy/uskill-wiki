from typing import List, Optional

from sqlalchemy import or_
from sqlalchemy.orm import Session

from src.models.learning_focus import LearningFocus
from src.models.language_skill import LanguageSkill
from src.models.resource import Resource, ResourceStatus
from src.models.user_role import UserRole
from src.schemas.resource import ResourceCreate


def create_pending_resource(db: Session, resource: ResourceCreate):
    """
    Takes a validated ResourceCreate schema, maps it to the database model,
    and saves it with a 'pending' status.
    """
    db_resource = Resource(
        title=resource.title,
        description=resource.description,
        content_url=resource.content_url,
        type=resource.type.value,
        language=resource.language,
        focus=resource.focus.value,
        language_skill=resource.language_skill.value if resource.language_skill else None,
        level=resource.level.value,
        target_audiences=[role.value for role in resource.target_audiences],
        tags=resource.tags,
        author_name=resource.author.name,
        author_email=resource.author.email,
        status=ResourceStatus.pending,
    )

    db.add(db_resource)
    db.commit()
    db.refresh(db_resource)
    return db_resource


def get_approved_resources(
    db: Session,
    role: Optional[UserRole] = None,
    language: Optional[str] = None,
    focus: Optional[LearningFocus] = None,
    language_skill: Optional[LanguageSkill] = None,
    tags: Optional[List[str]] = None,
):
    """
    Fetches only approved resources and applies the filters sent by the Flutter app.
    """
    query = db.query(Resource).filter(Resource.status == ResourceStatus.approved)

    if language:
        query = query.filter(Resource.language == language)

    if focus:
        query = query.filter(Resource.focus == focus.value)

    if language_skill:
        query = query.filter(Resource.language_skill == language_skill.value)

    if role:
        query = query.filter(Resource.target_audiences.like(f'%"{role.value}"%'))

    if tags:
        tag_conditions = [Resource.tags.like(f'%"{tag}"%') for tag in tags]
        query = query.filter(or_(*tag_conditions))

    return query.all()


def get_pending_resources(db: Session):
    """
    Fetches only pending resources.
    """
    return db.query(Resource).filter(Resource.status == ResourceStatus.pending).all()


def update_resource_status(db: Session, resource_id: str, status: ResourceStatus):
    """
    Used by admins to approve or reject a pending resource.
    """
    db.query(Resource).filter(Resource.id == resource_id).update(
        {"status": status.value}
    )
    db.commit()

    return db.query(Resource).filter(Resource.id == resource_id).first()


def get_all_tags(db: Session) -> List[str]:
    """
    Fetches all unique tags from all resources.
    """
    resources = db.query(Resource.tags).all()
    all_tags = set()
    for (tags,) in resources:
        if tags:
            for tag in tags:
                all_tags.add(tag)
    return list(all_tags)
