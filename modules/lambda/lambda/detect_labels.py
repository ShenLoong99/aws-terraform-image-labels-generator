import boto3
import sys
import json
import logging
import matplotlib.pyplot as plt
import matplotlib.patches as patches
from PIL import Image
from io import BytesIO

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s',
    datefmt='%H:%M:%S',
    handlers=[logging.StreamHandler(sys.stdout)]
)
logger = logging.getLogger("ImageLabeler")

def load_config():
    # This reads the file Terraform just created
    try:
        with open('config.json', 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        logger.error("config.json not found. Ensure Terraform has generated it.")
        sys.exit(1)

def get_automated_session():
    config = load_config()
    logger.info("Retrieving keys from SSM Parameter Store...")

    # Initialize SSM client
    ssm = boto3.client('ssm', region_name=config['region'])

    try:
        # Fetch the keys using the paths from config.json
        # WithDecryption=True is required for SecureString
        access_key = ssm.get_parameter(Name=config['access_key_path'], WithDecryption=True)['Parameter']['Value']
        secret_key = ssm.get_parameter(Name=config['secret_key_path'], WithDecryption=True)['Parameter']['Value']

        logger.info("✅ Successfully retrieved keys from SSM.")
        return boto3.Session(
            aws_access_key_id=access_key,
            aws_secret_access_key=secret_key,
            region_name=config['region']
        )
    except Exception as e:
        logger.error(f"❌ Failed to retrieve parameters: {str(e)}")
        sys.exit(1)

def run_analysis(BUCKET_NAME, IMAGE_NAME):
    logger.info(f"Starting analysis for image: {IMAGE_NAME} in bucket: {BUCKET_NAME}")

    session = get_automated_session()
    rekog_client = session.client('rekognition')
    s3_resource = session.resource('s3')

    # Verification Log: API Call
    logger.info("Calling Amazon Rekognition DetectLabels API...")
    response = rekog_client.detect_labels(
        Image={'S3Object': {'Bucket': BUCKET_NAME, 'Name': IMAGE_NAME}},
        MaxLabels=10
    )

    # Verification Log: Results Summary
    label_names = [label['Name'] for label in response['Labels']]
    logger.info(f"Rekognition found {len(label_names)} labels: {', '.join(label_names)}")

    # Download image from S3
    logger.info(f"Downloading {IMAGE_NAME} from S3 for visualization...")
    obj = s3_resource.Object(BUCKET_NAME, IMAGE_NAME)
    img_data = obj.get()['Body'].read()
    img = Image.open(BytesIO(img_data))
    width, height = img.size

    # --- START OF MATPLOTLIB CODE ---
    fig, ax = plt.subplots(1)
    ax.imshow(img)

    logger.info(f"Detected labels for {IMAGE_NAME}:")
    for label in response['Labels']:
        logger.info(f"- {label['Name']} ({label['Confidence']:.2f}%)")

        # Draw bounding boxes for each detected instance
        for instance in label.get('Instances', []):
            box = instance['BoundingBox']
            left = box['Left'] * width
            top = box['Top'] * height
            rect_width = box['Width'] * width
            rect_height = box['Height'] * height

            rect = patches.Rectangle(
                (left, top), rect_width, rect_height,
                linewidth=2, edgecolor='r', facecolor='none'
            )
            ax.add_patch(rect)
            plt.text(left, top, label['Name'], color='r', weight='bold', backgroundcolor='white')

    plt.title(f"Rekognition Results: {IMAGE_NAME}")
    plt.axis('off')
    logger.info("Displaying visualization window.")
    plt.show()
    # --- END OF MATPLOTLIB CODE ---

# --- Execution ---
if __name__ == "__main__":
    if len(sys.argv) < 3:
        logger.warning("Missing arguments. Usage: python detect_labels.py <bucket_name> <image_name>")
        sys.exit(1)

    target_bucket = sys.argv[1]
    target_image = sys.argv[2]

    run_analysis(target_bucket, target_image)
