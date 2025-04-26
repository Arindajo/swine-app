from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import SensorData, Pig
from .serializers import SensorDataSerializer
from alerts.models import Alert 

class LatestSensorDataForPig(APIView):
    def get(self, request, pig_id):
        try:
            # Check if the Pig with given pig_id exists
            if not Pig.objects.filter(id=pig_id).exists():
                return Response({'error': 'Pig not found.'}, status=status.HTTP_404_NOT_FOUND)
            
            # Fetch the latest sensor data for the pig
            latest = SensorData.objects.filter(pig__id=pig_id).order_by('-timestamp').first()
            
            if latest:
                serializer = SensorDataSerializer(latest)
                return Response(serializer.data)
            
            return Response({'error': 'No data found for this pig.'}, status=status.HTTP_404_NOT_FOUND)
        
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

from alerts.models import Alert  # ✅ Import the Alert model

class SensorDataCreateView(APIView):
    def post(self, request):
        serializer = SensorDataSerializer(data=request.data)
        if serializer.is_valid():
            sensor_data = serializer.save()  # Save and get the saved instance

            # ✅ Extract temperature from the saved data
            temperature = sensor_data.temperature
            pig = sensor_data.pig

            # ✅ Create alerts based on temperature thresholds
            if temperature < 38.5:
                Alert.objects.create(pig=pig, message="⚠️ Low temperature detected")
            elif temperature > 40.5:
                Alert.objects.create(pig=pig, message="🔥 High temperature detected")

            return Response(serializer.data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
