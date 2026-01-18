#!/bin/bash

set -e # Exit immediately if a command fails

echo "Starting Post-Deployment Role Verification for: $FUNCTION_NAME"

# Verify IAM Role Attachment
ROLE_ARN=$(aws lambda get-function-configuration --function-name "$FUNCTION_NAME" --query 'Role' --output text)
if [[ "$ROLE_ARN" == *"rekognition-lambda-role"* ]]; then
    echo "✅ Success: Correct IAM Role is attached."
    exit 0
else
    echo "⚠️ Warning: Role mismatch or unexpected naming convention."
    exit 1
fi
