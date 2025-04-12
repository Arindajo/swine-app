# authapp/serializers.py

from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import Pig 
User = get_user_model()

class RegisterSerializer(serializers.ModelSerializer):
    confirmpassword = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ['username', 'email', 'password', 'confirmpassword']
        extra_kwargs = {'password': {'write_only': True}}

    def validate(self, attrs):
        if attrs['password'] != attrs['confirmpassword']:
            raise serializers.ValidationError({"password": "Passwords do not match."})
        return attrs

    def create(self, validated_data):
        validated_data.pop('confirmpassword',None)
        user = User.objects.create_user(**validated_data)
        return user
class PigSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pig
        fields = '__all__'
        read_only_fields = ['owner']