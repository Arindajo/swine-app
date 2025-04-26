from django.db import models
from monitor.models import Pig  # Adjust if Pig is in another app

class Alert(models.Model):
    #pig = models.ForeignKey(Pig, on_delete=models.CASCADE)
    pig = models.ForeignKey(Pig, on_delete=models.CASCADE, null=True, blank=True)

    message = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    is_seen = models.BooleanField(default=False)

    def __str__(self):
        return f"{self.pig.name}: {self.message[:50]}"
