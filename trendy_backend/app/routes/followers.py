from fastapi import APIRouter

router = APIRouter()

@router.post("/follow/{user_id}")
def follow_user(user_id: int):
    return {"message": f"Successfully followed user with id {user_id}"}

@router.post("/unfollow/{user_id}")
def unfollow_user(user_id: int):
    return {"message": f"Successfully unfollowed user with id {user_id}"}
