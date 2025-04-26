from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
import requests
import pprint

@csrf_exempt
def ask_chatbot(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            query = data.get('query', '')

            # Construct the history array and payload
            chat_payload = {
                "history": [
                    {"role": "system", "content": "You are a friendly pig health assistant. Answer questions about swine fever and pig health."},
                    {"role": "user", "content": query}
                ],
                "query": query,
                "asset": "6f86fa41-0215-4f70-b449-18cc3c2673b1"
            }

            # Send the request to Andromeda Labs API
            response = requests.post(
                "https://andromedalabs-api.space/chat/b4cbfd28-ecf9-4ce9-b364-a20584562cb0/",
                headers={"Content-Type": "application/json"},
                data=json.dumps(chat_payload)
            )

            response_data = response.json()
            #print("🤖 API response:", response_data)
            pprint.pprint(response_data)

            # Return only the bot reply
            reply = response_data.get("response", "Sorry, I didn’t understand that.")
            return JsonResponse({"reply": reply})

        except Exception as e:
            return JsonResponse({"error": str(e)}, status=500)

    return JsonResponse({"error": "Invalid request method"}, status=400)
