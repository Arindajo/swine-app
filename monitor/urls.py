from django.urls import path
from .views import LatestSensorDataForPig
from .views import SensorDataCreateView

urlpatterns = [
    path('sensordata/', SensorDataCreateView.as_view(), name='sensor-data'),
    #path('sensordata/', LatestSensorDataForPig.as_view(), name='sensor-latest-by-pig'),
    path('sensordata/<int:pig_id>/', LatestSensorDataForPig.as_view(), name='sensor-latest-by-pig'),
]

