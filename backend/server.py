from fastapi import FastAPI, APIRouter, HTTPException, File, UploadFile, Form
from fastapi.responses import JSONResponse
from dotenv import load_dotenv
from starlette.middleware.cors import CORSMiddleware
from motor.motor_asyncio import AsyncIOMotorClient
import os
import logging
from pathlib import Path
from pydantic import BaseModel, Field
from typing import List, Optional, Dict, Any
import uuid
from datetime import datetime
import base64
import io
from PIL import Image


ROOT_DIR = Path(__file__).parent
load_dotenv(ROOT_DIR / '.env')

# MongoDB connection
mongo_url = os.environ['MONGO_URL']
client = AsyncIOMotorClient(mongo_url)
db = client[os.environ['DB_NAME']]

# Create the main app without a prefix
app = FastAPI()

# Create a router with the /api prefix
api_router = APIRouter(prefix="/api")


# Profile Models
class SocialLinks(BaseModel):
    linkedin: Optional[str] = None
    github: Optional[str] = None
    twitter: Optional[str] = None
    instagram: Optional[str] = None
    facebook: Optional[str] = None
    website: Optional[str] = None

class Skill(BaseModel):
    name: str
    level: int  # 1-100
    category: str  # "technical", "soft", "language", etc.

class Experience(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    company: str
    position: str
    start_date: str
    end_date: Optional[str] = None
    description: str
    technologies: List[str] = []

class Project(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    title: str
    description: str
    technologies: List[str] = []
    github_url: Optional[str] = None
    live_url: Optional[str] = None
    image: Optional[str] = None  # base64 encoded image

class Profile(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    # Basic Info
    name: str
    title: str
    description: str
    email: str
    phone: Optional[str] = None
    location: Optional[str] = None
    
    # Images (base64 encoded)
    avatar: Optional[str] = None
    background_image: Optional[str] = None
    
    # Social Links
    social_links: SocialLinks = Field(default_factory=SocialLinks)
    
    # Skills
    skills: List[Skill] = []
    
    # Experience
    experience: List[Experience] = []
    
    # Projects
    projects: List[Project] = []
    
    # Additional Info
    about_me: Optional[str] = None
    resume_url: Optional[str] = None
    
    # Timestamps
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)

class ProfileUpdate(BaseModel):
    name: Optional[str] = None
    title: Optional[str] = None
    description: Optional[str] = None
    email: Optional[str] = None
    phone: Optional[str] = None
    location: Optional[str] = None
    avatar: Optional[str] = None
    background_image: Optional[str] = None
    social_links: Optional[SocialLinks] = None
    skills: Optional[List[Skill]] = None
    experience: Optional[List[Experience]] = None
    projects: Optional[List[Project]] = None
    about_me: Optional[str] = None
    resume_url: Optional[str] = None

# Helper function to convert image to base64
def image_to_base64(image_bytes: bytes) -> str:
    return base64.b64encode(image_bytes).decode('utf-8')

# Helper function to resize image
def resize_image(image_bytes: bytes, max_size: tuple = (800, 600)) -> bytes:
    image = Image.open(io.BytesIO(image_bytes))
    image.thumbnail(max_size, Image.Resampling.LANCZOS)
    
    # Convert to RGB if necessary
    if image.mode in ('RGBA', 'LA', 'P'):
        image = image.convert('RGB')
    
    output = io.BytesIO()
    image.save(output, format='JPEG', quality=85)
    return output.getvalue()

# Profile Routes
@api_router.get("/profile", response_model=Profile)
async def get_profile():
    """Get user profile"""
    profile = await db.profile.find_one({})
    if not profile:
        # Create default profile
        default_profile = Profile(
            name="Ваше имя",
            title="Ваша профессия",
            description="Краткое описание о себе",
            email="your@email.com",
            about_me="Расскажите о себе подробнее..."
        )
        await db.profile.insert_one(default_profile.dict())
        return default_profile
    
    return Profile(**profile)

@api_router.put("/profile", response_model=Profile)
async def update_profile(profile_update: ProfileUpdate):
    """Update user profile"""
    update_data = profile_update.dict(exclude_unset=True)
    update_data["updated_at"] = datetime.utcnow()
    
    result = await db.profile.update_one(
        {},
        {"$set": update_data},
        upsert=True
    )
    
    if result.matched_count == 0 and result.upserted_id is None:
        raise HTTPException(status_code=500, detail="Failed to update profile")
    
    updated_profile = await db.profile.find_one({})
    return Profile(**updated_profile)

@api_router.post("/profile/upload-image")
async def upload_image(file: UploadFile = File(...), image_type: str = "avatar"):
    """Upload and convert image to base64"""
    logger.info(f"Upload image called with image_type: '{image_type}'")
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="File must be an image")
    
    # Read image
    image_bytes = await file.read()
    
    # Resize image based on type
    if image_type == "avatar":
        resized_image = resize_image(image_bytes, (300, 300))
    else:
        resized_image = resize_image(image_bytes, (1200, 600))
    
    # Convert to base64
    base64_image = image_to_base64(resized_image)
    base64_with_prefix = f"data:image/jpeg;base64,{base64_image}"
    
    # Update profile with new image
    update_field = "avatar" if image_type == "avatar" else "background_image"
    logger.info(f"Updating field: '{update_field}' for image_type: '{image_type}'")
    await db.profile.update_one(
        {},
        {"$set": {update_field: base64_with_prefix, "updated_at": datetime.utcnow()}},
        upsert=True
    )
    
    return {"message": "Image uploaded successfully", "image": base64_with_prefix}

# Keep existing routes for backward compatibility
@api_router.get("/")
async def root():
    return {"message": "Portfolio API is running"}

class StatusCheck(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    client_name: str
    timestamp: datetime = Field(default_factory=datetime.utcnow)

class StatusCheckCreate(BaseModel):
    client_name: str

@api_router.post("/status", response_model=StatusCheck)
async def create_status_check(input: StatusCheckCreate):
    status_dict = input.dict()
    status_obj = StatusCheck(**status_dict)
    _ = await db.status_checks.insert_one(status_obj.dict())
    return status_obj

@api_router.get("/status", response_model=List[StatusCheck])
async def get_status_checks():
    status_checks = await db.status_checks.find().to_list(1000)
    return [StatusCheck(**status_check) for status_check in status_checks]

# Include the router in the main app
app.include_router(api_router)

app.add_middleware(
    CORSMiddleware,
    allow_credentials=True,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

@app.on_event("shutdown")
async def shutdown_db_client():
    client.close()
