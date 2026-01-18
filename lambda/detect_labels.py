import boto3
import json
import matplotlib.pyplot as plt
import matplotlib.patches as patches
from PIL import Image
from io import BytesIO

def get_secret_keys():
    # This client uses the default environment/IAM role to access Secrets Manager
    client = boto3.client('secretsmanager', region_name='ap-southeast-1')
    response = client.get_secret_value(SecretId='rekognition-image-labels-dev-credentials-new')
    return json.loads(response['SecretString'])

def analyze_image_with_ui(bucket, photo):
    # --- NEW: Retrieve keys and setup session ---
    keys = get_secret_keys()
    session = boto3.Session(
        aws_access_key_id=keys['access_key'],
        aws_secret_access_key=keys['secret_key'],
        region_name='ap-southeast-1'
    )

    # Use the session to create clients (they now use the secret keys)
    rekog_client = session.client('rekognition')
    s3_resource = session.resource('s3')

    # 1. Call Rekognition DetectLabels API
    response = rekog_client.detect_labels(
        Image={'S3Object': {'Bucket': bucket, 'Name': photo}},
        MaxLabels=10
    )

    # 2. Download image from S3 to memory
    obj = s3_resource.Object(bucket, photo)
    img_data = obj.get()['Body'].read()
    img = Image.open(BytesIO(img_data))
    width, height = img.size

    # 3. Create the plot
    fig, ax = plt.subplots(1)
    ax.imshow(img)

    print(f"Detected labels for {photo}:")
    for label in response['Labels']:
        print(f"- {label['Name']} ({label['Confidence']:.2f}%)")

        # 4. Draw bounding boxes
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
            plt.text(left, top, label['Name'], color='white',
                     bbox=dict(facecolor='red', alpha=0.5))

    plt.title(f"Rekognition Results: {photo}")
    plt.show()

# --- Execution ---
BUCKET_NAME = "rekognition-image-labels-images-bucket-XXXX"
IMAGE_NAME = "test_image.jpg"

analyze_image_with_ui(BUCKET_NAME, IMAGE_NAME)
