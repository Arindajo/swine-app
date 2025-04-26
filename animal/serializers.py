from rest_framework import serializers
from .models import Pig

class PigSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pig
        fields = '__all__'
