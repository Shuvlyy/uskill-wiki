import enum


class UserRole(str, enum.Enum):
    student = "student"
    teacher = "teacher"
    staff = "staff"
