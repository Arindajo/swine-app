from django.db import models

# Create your models here.
#from django.db import models

class Pig(models.Model):
   

    name = models.CharField(max_length=100)
    breed = models.CharField(max_length=100)
    date_of_birth = models.DateField()
    

    def __str__(self):
        return self.name
