#!/bin/bash
echo "--- Starting Local Environment Setup ---"

# 1. Install Python dependencies
pip install boto3 matplotlib Pillow

# 2. Check if AWS CLI is installed
if ! command -v aws &> /dev/null
then
    echo "AWS CLI not found. Please install it first."
    exit 1
fi

echo "--- Setup Complete ---"
