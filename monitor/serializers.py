from rest_framework import serializers
from .models import SensorData

class SensorDataSerializer(serializers.ModelSerializer):
    class Meta:
        model = SensorData
        fields = '__all__'
        extra_kwargs = {
            'user': {'required': False}  # 👈 This makes the field optional
        }
