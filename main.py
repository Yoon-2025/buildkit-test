import os
import json
from env_loader import resolve_env

def lambda_handler(event, context):
    """
    Lambda 핸들러
    ENV_AT 환경변수에서 sm@ 또는 ps@ 값을 가져와 resolve_env 호출
    """
    env_path = os.environ.get("ENV_AT")
    if not env_path:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": "ENV_AT environment variable is not set"})
        }

    try:
        resolved = resolve_env(env_path)
        return resolved
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
