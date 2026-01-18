#!/bin/bash

set -e # Exit immediately if a command fails

echo "Starting Post-Deployment Lambda Verification for: $FUNCTION_NAME"

# Check Function State (Ensures Lambda is not 'Pending' or 'Failed')
STATE=$(aws lambda get-function --function-name "$FUNCTION_NAME" --query 'Configuration.State' --output text)

if [ "$STATE" == "Active" ]; then
    echo "✅ Success: Lambda function is Active."
    exit 0
else
    echo "❌ Failure: Lambda function is in state: $STATE"
    exit 1
fi
