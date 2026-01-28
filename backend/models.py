from tortoise import fields, models
from tortoise.contrib.pydantic import pydantic_model_creator

class User(models.Model):
    id = fields.IntField(pk=True)
    name = fields.CharField(max_length=255)
    email = fields.CharField(max_length=255, unique=True)
    password = fields.CharField(max_length=255)
    account_state = fields.CharField(max_length=50, default="active")
    profile_picture = fields.TextField(null=True)

    class Meta:
        table = "users"

class Score(models.Model):
    id = fields.IntField(pk=True)
    score = fields.FloatField()
    user = fields.ForeignKeyField("models.User", related_name="scores")
    date = fields.DateField(auto_now_add=True)
    created_at = fields.DatetimeField(auto_now_add=True)

    class Meta:
        table = "scores"
        unique_together = (("user", "date"),)

User_Pydantic = pydantic_model_creator(User, name="User")
UserIn_Pydantic = pydantic_model_creator(User, name="UserIn", exclude_readonly=True)
ProfileUpdate_Pydantic = pydantic_model_creator(User, name="ProfileUpdate", include=("profile_picture",))
Score_Pydantic = pydantic_model_creator(Score, name="Score")
ScoreIn_Pydantic = pydantic_model_creator(Score, name="ScoreIn", exclude_readonly=True)
