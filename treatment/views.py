from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .serializers import TreatmentSerializer

@api_view(['POST'])
def add_treatment(request):
    serializer = TreatmentSerializer(data=request.data)
    if serializer.is_valid():
        print("✅ Validated data:", serializer.validated_data)
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
