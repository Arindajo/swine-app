from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import Alert

@api_view(['GET'])
def get_alerts(request, pig_id):
    alerts = Alert.objects.filter(pig_id=pig_id, is_seen=False)
    return Response([
        {
            "message": alert.message,
            "created_at": alert.created_at
        } for alert in alerts
    ])
