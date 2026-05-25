import json
import os
import urllib3

http = urllib3.PoolManager()

def lambda_handler(event, context):
    webhook_url = os.environ.get('DISCORD_WEBHOOK')
    
    print("--- Event Received ---")
    print(json.dumps(event)) 
    
    try:
        sns_message = event['Records'][0]['Sns']['Message']
    except Exception as e:
        print(f"Error parsing SNS: {e}")
        sns_message = "No message content found."
    
    payload = {
        "content": "🚨 **AWS Fargate Alert** 🚨",
        "embeds": [{
            "title": "Unhealthy Service Detected",
            "description": f"The following alert was triggered:\n{sns_message}", # Removed code blocks for testing
            "color": 15158528 # Red
        }]
    }

    # 4. Post to Discord
    encoded_data = json.dumps(payload).encode('utf-8')
    print(f"Sending to Discord: {webhook_url[:20]}...") # Log partial URL for safety
    
    response = http.request('POST', webhook_url, body=encoded_data, headers={'Content-Type': 'application/json'})
    
    print(f"Discord Response: {response.status}")
    print(f"Discord Body: {response.data.decode('utf-8')}")

    return {"statusCode": response.status}