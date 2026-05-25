import os
import sys  
import json
import boto3
import requests

# --- CONFIGURATION ---
CLUSTER_NAME = "Kelvin-Cloud-Project-cluster"
SERVICE_NAME = "Kelvin-Cloud-Project-service"
WEBHOOK_URL  = os.environ.get("DISCORD_WEBHOOK")
# ---------------------

def check_fargate_health():
    # --- SAFETY CHECK ---
    if not WEBHOOK_URL:
        print("❌ ERROR: DISCORD_WEBHOOK environment variable is not set.")
        print("Fix: run 'export DISCORD_WEBHOOK=your_url' then try again.")
        sys.exit(1) # Exit with code 1 (Standard for "General Error")

    try:
        ecs = boto3.client('ecs')
        
        # 1. Ask ECS about your service
        response = ecs.describe_services(
            cluster=CLUSTER_NAME,
            services=[SERVICE_NAME]
        )
        
        if not response['services']:
            print(f"❌ ERROR: Service {SERVICE_NAME} not found in cluster {CLUSTER_NAME}.")
            sys.exit(1)

        service = response['services'][0]
        running = service['runningCount']
        desired = service['desiredCount']
        
        print(f"Service status: {running}/{desired} tasks running.")

        # 2. Logic: If running tasks are less than desired, send alert
        if running < desired:
            message = {
                "content": f"🚨 **FARGATE ALERT** 🚨\nService: `{SERVICE_NAME}`\nStatus: {running}/{desired} tasks are running. \nCheck CloudWatch logs immediately!"
            }
            
            requests.post(WEBHOOK_URL, data=json.dumps(message), headers={'Content-Type': 'application/json'})
            print("Alert sent to Discord!")
        else:
            print("Everything is healthy. No alert needed.")

    except Exception as e:
        print(f"❌ UNEXPECTED ERROR: {e}")
        sys.exit(1)

if __name__ == "__main__":
    check_fargate_health()