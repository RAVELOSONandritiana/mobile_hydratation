from fastapi import FastAPI, HTTPException, Body, Depends, Request
from tortoise.contrib.fastapi import register_tortoise
from models import User, Score, User_Pydantic, UserIn_Pydantic, Score_Pydantic
from schemas import (
    UserCreate, UserLogin, UpdateEmailRequest, 
    UpdateNameRequest, UpdatePasswordRequest, ScoreCreate,
    UpdateProfileRequest
)
from passlib.context import CryptContext
from datetime import date
from fastapi.middleware.cors import CORSMiddleware
from tortoise.contrib.fastapi import register_tortoise

app = FastAPI(title="Hydratation API")

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

@app.middleware("http")
async def catch_exceptions_middleware(request: Request, call_next):
    try:
        return await call_next(request)
    except Exception as e:
        import traceback
        print(f"ERROR: {e}")
        traceback.print_exc()
        return HTTPException(status_code=500, detail=str(e))

# Tortoise configuration
TORTOISE_ORM = {
    "connections": {"default": "mysql://admin:123456@127.0.0.1:3306/hydratation"},
    "apps": {
        "models": {
            "models": ["models"],
            "default_connection": "default",
        }
    },
}

@app.post("/users/create")
async def create_user(user: UserCreate):
    print(f"DEBUG: Creating user with email: {user.email}")
    user_exists = await User.filter(email=user.email).exists()
    if user_exists:
        print(f"DEBUG: User already exists: {user.email}")
        raise HTTPException(status_code=400, detail="Account already exists")
    
    hashed_password = pwd_context.hash(user.password)
    user_obj = await User.create(
        name=user.name,
        email=user.email,
        password=hashed_password
    )
    return await User_Pydantic.from_tortoise_orm(user_obj)

# Handling GET with body to match Flutter's dio.get(..., data: {...})
@app.get("/users/signin")
async def sign_in_get(data: UserLogin = Body(...)):
    print(f"DEBUG: Sign-in attempt for email: {data.email}")
    user = await User.get_or_none(email=data.email)
    if not user:
        print(f"DEBUG: User not found: {data.email}")
        raise HTTPException(status_code=404, detail="Account missing")
    
    is_valid = pwd_context.verify(data.password, user.password)
    print(f"DEBUG: Password verification for {data.email}: {is_valid}")
    if not is_valid:
        raise HTTPException(status_code=404, detail="Account missing")
    return await User_Pydantic.from_tortoise_orm(user)

# Also providing POST for better compatibility if needed
@app.post("/users/signin")
async def sign_in_post(data: UserLogin):
    user = await User.get_or_none(email=data.email)
    if not user or not pwd_context.verify(data.password, user.password):
        raise HTTPException(status_code=404, detail="Account missing")
    return await User_Pydantic.from_tortoise_orm(user)

@app.put("/users/updatemail")
async def update_email(request: UpdateEmailRequest):
    user = await User.get_or_none(id=request.id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user.email = request.name # Correct field mapping
    await user.save()
    return {"status": "success"}

@app.put("/users/updatename")
async def update_name(request: UpdateNameRequest):
    user = await User.get_or_none(id=request.id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user.name = request.name
    await user.save()
    return {"status": "success"}

@app.put("/users/updatepassword")
async def update_password(request: UpdatePasswordRequest):
    user = await User.get_or_none(id=request.id)
    if not user or not pwd_context.verify(request.current_password, user.password):
        raise HTTPException(status_code=400, detail="Invalid password")
    user.password = pwd_context.hash(request.password)
    await user.save()
    return {"status": "success"}

@app.put("/users/updateprofile")
async def update_profile(request: UpdateProfileRequest):
    user = await User.get_or_none(id=request.id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user.profile_picture = request.profile_picture
    await user.save()
    return {"status": "success"}

@app.post("/compte/score")
async def add_score(score_data: ScoreCreate):
    user = await User.get_or_none(id=score_data.id_user)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    today = date.today()
    score_obj, created = await Score.get_or_create(
        user=user, 
        date=today,
        defaults={"score": score_data.score}
    )
    
    if not created:
        score_obj.score += score_data.score
        await score_obj.save()
        
    return {"status": "success", "total_today": score_obj.score}

@app.get("/users/{user_id}/scores")
async def get_user_scores(user_id: int):
    scores = await Score.filter(user_id=user_id).order_by("-date").all()
    return [await Score_Pydantic.from_tortoise_orm(s) for s in scores]

@app.get("/users/{user_id}/today")
async def get_today_score(user_id: int):
    today = date.today()
    score_obj = await Score.get_or_none(user_id=user_id, date=today)
    if not score_obj:
        return {"total_today": 0.0}
    return {"total_today": score_obj.score}

@app.get("/users/ranking")
async def get_user_ranking():
    today = date.today()
    # Get all users
    users = await User.all()
    # Get all scores for today
    today_scores = await Score.filter(date=today).all()
    score_map = {s.user_id: s.score for s in today_scores}
    
    ranking = []
    for u in users:
        ranking.append({
            "name": u.name,
            "score": score_map.get(u.id, 0.0),
            "profile_picture": u.profile_picture or ""
        })
    
    # Sort by score descending
    ranking.sort(key=lambda x: x["score"], reverse=True)
    return ranking

@app.get("/users/{user_id}")
async def get_user_profile(user_id: int):
    user = await User.get_or_none(id=user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return await User_Pydantic.from_tortoise_orm(user)

register_tortoise(
    app,
    db_url="mysql://admin:123456@127.0.0.1:3306/hydratation",
    modules={"models": ["models"]},
    generate_schemas=True,
    add_exception_handlers=True,
)
