# models.py
from django.conf import settings
from django.db import models

class SensorData(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, null=True, blank=True)  # Use AUTH_USER_MODEL
    temperature = models.FloatField()
    activity_level = models.CharField(max_length=255)
    timestamp = models.CharField(max_length=255)

    def __str__(self):
        return f"SensorData at {self.timestamp}"
user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        null=True,     # allow nulls in the database
        blank=True )