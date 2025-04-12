from django.urls import path
from .views import SensorDataListCreateView

urlpatterns = [
    path('sensordata/', SensorDataListCreateView.as_view(), name='sensor-data'),
]
