# urls.py
from django.urls import path
from .views import add_treatment

urlpatterns = [
    path('add-treatment/', add_treatment, name='add-treatment'),
]
