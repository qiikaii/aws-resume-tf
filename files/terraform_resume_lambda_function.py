import boto3
import os
import uuid
from datetime import datetime, timezone, timedelta

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['CONNECTIONS_SESSION'])

def lambda_handler(event, context):
    print(event)
    headers = event.get("headers", {})
    cookies = event.get("cookies", "")
    ip = headers.get("x-forwarded-for", "unknown").split(",")[0].strip()
    ua = headers.get("user-agent", "unknown")

    # Check for session cookie
    session_id = None
    for cookie in cookies:
        if cookie.strip().startswith("sessionID="):
            session_id = cookie.strip().split("=")[1]
            print(session_id)
            break

    if not session_id:
        # New session
        session_id = str(uuid.uuid4())
        now = datetime.now(timezone.utc)
        ttl_expiry = int((now + timedelta(hours=168)).timestamp())

        table.put_item(Item={
            "sessionID": session_id,
            "ipAddress": ip,
            "userAgent": ua,
            "visitTime": now.isoformat(),
            "ttl": ttl_expiry
        })

    # Get unique visitor count
    resp = table.scan(Select='COUNT')
    count = resp['Count']

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Credentials": "true",
            "Set-Cookie": f"sessionID={session_id}; Domain=.sidpanic.io; HttpOnly; Path=/; Max-Age=86400; SameSite=None; Secure"
        },
        "body": f'{{"count": {count}}}'
    }
