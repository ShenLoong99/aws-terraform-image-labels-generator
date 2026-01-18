#!/bin/bash
# Get the bucket name from Terraform Output (Requires TF CLI logged in)
BUCKET=$(terraform output -raw s3_bucket_name)

# Get the Region (Usually hardcoded in variables or also an output)
REGION=$(terraform output -raw aws_region)

# Get the Access Key Name
ACCESS_PATH=$(terraform output -raw access_key_path)

# Get the Secret Name
SECRET_PATH=$(terraform output -raw secret_key_path)

# 4. Create the config.json manually
echo "{
  \"bucket_name\": \"$BUCKET\",
  \"region\": \"$REGION\",
  \"access_key_path\": \"$ACCESS_PATH\",
  \"secret_key_path\": \"$SECRET_PATH\"
}" > config.json

echo "config.json generated successfully for local testing."
