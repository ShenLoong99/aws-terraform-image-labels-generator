import boto3
import os
import json
import urllib.parse

# Initialize outside the handler to reuse connection across warm starts
rekognition = boto3.client("rekognition")

def lambda_handler(event, context):
    try:
        # 1. Extract Bucket and Key from the incoming S3 Event record
        bucket = event['Records'][0]['s3']['bucket']['name']
        key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'])
        
        # 2. Call Rekognition directly using S3 location
        response = rekognition.detect_labels(
            Image={'S3Object': {'Bucket': bucket, 'Name': key}},
            MaxLabels=10,
            MinConfidence=int(os.environ.get("MIN_CONFIDENCE", 70))
        )
        
        # 3. Print results to CloudWatch Logs for debugging
        print(f"Results for {key}: {json.dumps(response['Labels'])}")
        
        return {"statusCode": 200, "body": response["Labels"]}
    except Exception as e:
        print(f"Error processing {key} from bucket {bucket}. Error: {str(e)}")
        raise e