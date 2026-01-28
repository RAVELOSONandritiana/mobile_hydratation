from pydantic import BaseModel, EmailStr
from typing import Optional

class UserCreate(BaseModel):
    name: str
    email: EmailStr
    password: str

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class UpdateEmailRequest(BaseModel):
    id: int
    name: str  # The Flutter app sends the new email in the 'name' field

class UpdateNameRequest(BaseModel):
    id: int
    name: str

class UpdatePasswordRequest(BaseModel):
    id: int
    current_password: str
    password: str

class UpdateProfileRequest(BaseModel):
    id: int
    profile_picture: str

class ScoreCreate(BaseModel):
    score: float
    id_user: int
