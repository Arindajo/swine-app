from django.urls import path
from .views import ReportListView, SensorDataCreateView

urlpatterns = [
    path('reports/', ReportListView.as_view(), name='report-list'),
    path('api/sensor-data/', SensorDataCreateView.as_view(), name='sensor-data-create'),
]
