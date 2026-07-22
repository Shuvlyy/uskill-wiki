import json
import os
import sys

from src.database import Base, SessionLocal, engine
from src.models.resource import Resource


def populate(json_filepath: str):
    print(f"Reading data from {json_filepath}...")
    try:
        with open(json_filepath, "r", encoding="utf-8") as file:
            resources_data = json.load(file)
    except Exception as e:
        print(f"An error occurred while loading JSON file: {e}")
        return

    print("Dropping existing tables...")
    Base.metadata.drop_all(bind=engine)

    print("Creating fresh tables...")
    Base.metadata.create_all(bind=engine)

    if not os.path.exists(json_filepath):
        print(f"Error: Could not find {json_filepath}")
        return

    db = SessionLocal()

    try:
        added_count = 0
        for item in resources_data:
            new_resource = Resource(
                title=item["title"],
                description=item["description"],
                content_url=item["content_url"],
                type=item["type"],
                language=item["language"],
                focus=item["focus"],
                language_skill=item.get("language_skill"),
                level=item["level"],
                target_audiences=item["target_audiences"],
                tags=item["tags"],
                linguistic_objectives=item.get("linguistic_objectives"),
                author_name=item["author_name"],
                author_email=item["author_email"],
                status=item["status"],
            )
            db.add(new_resource)
            added_count += 1

        db.commit()
        print(f"Success! Inserted {added_count} resources into the database.")

    except Exception as e:
        print(f"An error occurred: {e}")
        db.rollback()
    finally:
        db.close()


if __name__ == "__main__":
    if len(sys.argv) <= 1:
        print("Please provide a JSON file in the CLI (`python seeder.py file.json`).")
        sys.exit(84)

    populate(sys.argv[1])
