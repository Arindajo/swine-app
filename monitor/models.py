from django.conf import settings
from django.db import models
import uuid

class Pig(models.Model):
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='monitor_pigs'
    )
    pig_id = models.UUIDField(default=uuid.uuid4, editable=False, unique=True)
    name = models.CharField(max_length=100)
    breed = models.CharField(max_length=100, blank=True, null=True)
    date_of_birth = models.DateField(blank=True, null=True)
    
    def __str__(self):
        return f"{self.name} ({self.pig_id})"



class SensorData(models.Model):
    pig = models.ForeignKey(
        Pig,
        on_delete=models.CASCADE,
        related_name='sensor_data'
    )
    temperature = models.FloatField()
    activity_level = models.CharField(max_length=255)
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Data for {self.pig.name} at {self.timestamp}"
