from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Report, SensorData
from .serializers import ReportSerializer, SensorDataSerializer

class ReportListView(APIView):
    def get(self, request):
        reports = Report.objects.all().order_by('-created_at')
        serializer = ReportSerializer(reports, many=True)
        return Response({'reports': serializer.data})

class SensorDataCreateView(APIView):
    def post(self, request):
        serializer = SensorDataSerializer(data=request.data)
        if serializer.is_valid():
            sensor_data = serializer.save()

            # Automatically generate report
            content = f"Temperature: {sensor_data.temperature} °C, Activity Level: {sensor_data.activity_level}"
            Report.objects.create(title=f"Pig {sensor_data.pig.id} Report", content=content)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
