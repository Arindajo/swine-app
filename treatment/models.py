# models.py
from django.db import models

class Pig(models.Model):
    name = models.CharField(max_length=100)

    def __str__(self):
        return self.name

class Treatment(models.Model):
    pig = models.ForeignKey(Pig, on_delete=models.CASCADE, related_name='treatments')
    
    treatment_type = models.CharField(max_length=100)
    notes = models.TextField(default='No notes')

    date = models.DateField()

    def __str__(self):
        return f"{self.pig.name} - {self.treatment_type}"
