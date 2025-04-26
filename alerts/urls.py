from django.urls import path
from . import views

urlpatterns = [
    path('alerts/', views.get_alerts, name='get_alerts'),
]
