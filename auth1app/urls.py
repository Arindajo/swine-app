
from django.urls import path
from .views import RegisterView, LoginView
from .views import PigListCreateView


urlpatterns = [
    path('api/register/', RegisterView.as_view(), name='register'),
    path('api/login/', LoginView.as_view(), name='login'),
    path('api/pigs/', PigListCreateView.as_view(), name='pig-list-create'),
]


