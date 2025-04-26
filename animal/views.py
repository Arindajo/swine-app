from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Pig
from .serializers import PigSerializer

# Create Pig view (you already have this)
class PigCreateAPIView(APIView):
    def post(self, request):
        serializer = PigSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# New Pig List view (this is what you're adding)
class PigListAPIView(APIView):
    def get(self, request):
        pigs = Pig.objects.all()  # Fetch all pigs from the database
        serializer = PigSerializer(pigs, many=True)  # Serialize the pigs
        return Response(serializer.data, status=status.HTTP_200_OK)



class PigDeleteAPIView(APIView):
    def delete(self, request, pk):
        try:
            pig = Pig.objects.get(pk=pk)
            pig.delete()
            return Response({"message": "Pig deleted"}, status=status.HTTP_204_NO_CONTENT)
        except Pig.DoesNotExist:
            return Response({"error": "Pig not found"}, status=status.HTTP_404_NOT_FOUND)
