from rest_framework.response import Response
from rest_framework import status
from rest_framework import generics, permissions
from .models import SensorData
from .serializers import SensorDataSerializer
class SensorDataListCreateView(generics.ListCreateAPIView):
    queryset = SensorData.objects.all().order_by('-timestamp')
    serializer_class = SensorDataSerializer
    permission_classes = [permissions.AllowAny]

    def post(self, request, *args, **kwargs):
        print("Request content type:", request.content_type)  # Debug line
        print("Request body:", request.body.decode())         # Debug line

        return self.create(request, *args, **kwargs)
