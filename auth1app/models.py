from django.db import models
from django.conf import settings  # Import settings to reference the custom user model
from django.contrib.auth.models import AbstractUser 
class CustomUser(AbstractUser):
    phone_number = models.CharField(max_length=15, unique=True, null=True, blank=True)

    def __str__(self):
        return self.username

class Pig(models.Model):
    owner = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)  # Reference the custom user model
    name = models.CharField(max_length=100)
    temperature = models.CharField(max_length=20, default='N/A')
    activity = models.CharField(max_length=20, default='N/A')
    weight = models.CharField(max_length=20, default='N/A')
    health_status = models.CharField(max_length=100, default='Unknown')

    def __str__(self):
        return self.name
