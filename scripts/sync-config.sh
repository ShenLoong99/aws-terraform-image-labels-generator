#!/bin/bash
# 1. Get the bucket name from Terraform Output (Requires TF CLI logged in)
BUCKET=$(terraform output -raw s3_bucket_name)

# 2. Get the Region (Usually hardcoded in variables or also an output)
REGION=$(terraform output -raw aws_region)

# 3. Get the Secret Name
SECRET_NAME=$(terraform output -raw secret_name)

# 4. Create the config.json manually
echo "{
  \"bucket_name\": \"$BUCKET\",
  \"region\": \"$REGION\",
  \"secret_id\": \"$SECRET_NAME\"
}" > config.json

echo "config.json generated successfully for local testing."
