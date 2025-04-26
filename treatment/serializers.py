from rest_framework import serializers
from .models import Treatment
from animal.models import Pig

class TreatmentSerializer(serializers.ModelSerializer):
    pig = serializers.PrimaryKeyRelatedField(queryset=Pig.objects.all())

    class Meta:
        model = Treatment
        fields = ['id', 'pig', 'treatment_type', 'notes', 'date']
