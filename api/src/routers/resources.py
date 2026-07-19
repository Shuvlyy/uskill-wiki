from typing import List, Optional

from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

import src.crud as crud
from src.dependencies import get_db, verify_admin
from src.models.learning_focus import LearningFocus
from src.models.language_skill import LanguageSkill
from src.models.language_level import LanguageLevel
from src.models.resource import ResourceStatus
from src.models.user_role import UserRole
from src.schemas.resource import ResourceCreate, ResourceResponse

router = APIRouter(prefix="/resources", tags=["Resources"])


@router.post("/", response_model=ResourceResponse, status_code=201)
def submit_resource(resource: ResourceCreate, db: Session = Depends(get_db)):
    """Submit a new resource to the pending list."""

    db_res = crud.create_pending_resource(db, resource)

    res_dict = db_res.__dict__.copy()
    res_dict["author"] = {"name": db_res.author_name, "email": db_res.author_email}

    return res_dict


@router.get("/", response_model=List[ResourceResponse])
def get_resources(
    role: Optional[UserRole] = Query(None),
    language: Optional[str] = Query(None),
    level: Optional[LanguageLevel] = Query(None),
    focus: Optional[LearningFocus] = Query(None),
    language_skill: Optional[LanguageSkill] = Query(None),
    tags: Optional[List[str]] = Query(None),
    linguistic_objectives: Optional[List[str]] = Query(None),
    db: Session = Depends(get_db),
):
    """Get all APPROVED resources, filtering them based on query parameters."""
    db_resources = crud.get_approved_resources(db, role, language, level, focus, language_skill, linguistic_objectives, tags)

    results = []
    for r in db_resources:
        r_dict = r.__dict__.copy()
        r_dict["author"] = {"name": r.author_name, "email": r.author_email}
        results.append(r_dict)

    return results


@router.get("/tags", response_model=List[str])
def get_tags(db: Session = Depends(get_db)):
    """Get all unique tags from all resources."""
    return crud.get_all_tags(db)


@router.get("/pending", response_model=List[ResourceResponse])
def get_pending_resources(db: Session = Depends(get_db), _=Depends(verify_admin)):
    """Get all PENDING resources."""
    db_resources = crud.get_pending_resources(db)

    results = []
    for r in db_resources:
        r_dict = r.__dict__.copy()
        r_dict["author"] = {"name": r.author_name, "email": r.author_email}
        results.append(r_dict)

    return results


@router.patch("/{resource_id}/status", response_model=ResourceResponse)
def update_status(resource_id: str, status: ResourceStatus = Query(...), db: Session = Depends(get_db), _=Depends(verify_admin)):
    """Update resource status (approve/reject)."""
    db_res = crud.update_resource_status(db, resource_id, status)

    if not db_res:
        from fastapi import HTTPException
        raise HTTPException(status_code=404, detail="Resource not found")

    res_dict = db_res.__dict__.copy()
    res_dict["author"] = {"name": db_res.author_name, "email": db_res.author_email}
    return res_dict
