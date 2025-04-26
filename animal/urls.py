from django.urls import path
from .views import PigCreateAPIView, PigListAPIView, PigDeleteAPIView

urlpatterns = [
    path('add/', PigCreateAPIView.as_view(), name='add-pig'),
    path('list/', PigListAPIView.as_view(), name='animal_list'),
    path('delete/<int:pk>/', PigDeleteAPIView.as_view(), name='pig_delete'),
]
