from django.db import models

class Pig(models.Model):
    name = models.CharField(max_length=100)

    def __str__(self):
        return self.name

class SensorData(models.Model):
    pig = models.ForeignKey(Pig, on_delete=models.CASCADE)
    temperature = models.FloatField()
    activity_level = models.CharField(max_length=50)
    timestamp = models.DateTimeField(auto_now_add=True)

class Report(models.Model):
    title = models.CharField(max_length=100)
    content = models.TextField()  # e.g., "Temperature: 39.0 °C, Activity Level: High Activity"
    created_at = models.DateTimeField(auto_now_add=True)
