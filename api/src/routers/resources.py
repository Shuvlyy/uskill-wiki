from typing import List, Optional

from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

import src.crud as crud
from src.dependencies import get_db
from src.models.learning_focus import LearningFocus
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
    focus: Optional[LearningFocus] = Query(None),
    tags: Optional[List[str]] = Query(None),
    db: Session = Depends(get_db),
):
    """Get all APPROVED resources, filtering them based on query parameters."""
    db_resources = crud.get_approved_resources(db, role, language, focus, tags)

    results = []
    for r in db_resources:
        r_dict = r.__dict__.copy()
        r_dict["author"] = {"name": r.author_name, "email": r.author_email}
        results.append(r_dict)

    return results
