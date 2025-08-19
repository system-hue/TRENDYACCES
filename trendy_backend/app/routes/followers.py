from fastapi import APIRouter

router = APIRouter()

@router.post("/{user_id}/follow")
def follow_user(user_id: int):
    return {"message": f"Successfully followed user with id {user_id}"}

@router.post("/{user_id}/unfollow")
def unfollow_user(user_id: int):
    return {"message": f"Successfully unfollowed user with id {user_id}"}
