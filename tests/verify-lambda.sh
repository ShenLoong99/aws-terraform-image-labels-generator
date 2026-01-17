#!/bin/bash
# scripts/verify-lambda.sh

set -e # Exit immediately if a command fails

echo "Starting Post-Deployment Verification for: $FUNCTION_NAME"

# Check Function State (Ensures Lambda is not 'Pending' or 'Failed')
STATE=$(aws lambda get-function --function-name "$FUNCTION_NAME" --query 'Configuration.State' --output text)

if [ "$STATE" == "Active" ]; then
    echo "✅ Success: Lambda function is Active."
else
    echo "❌ Failure: Lambda function is in state: $STATE"
    exit 1
fi

# Verify IAM Role Attachment
ROLE_ARN=$(aws lambda get-function-configuration --function-name "$FUNCTION_NAME" --query 'Role' --output text)
if [[ "$ROLE_ARN" == *"rekognition-lambda-role"* ]]; then
    echo "✅ Success: Correct IAM Role is attached."
else
    echo "⚠️ Warning: Role mismatch or unexpected naming convention."
fi
