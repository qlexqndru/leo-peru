#!/usr/bin/env bash

echo "Creating Lambda deployment package..."

# Clean up any previous builds
rm -rf lambda-package deployment-package.zip

# Create package directory
mkdir -p lambda-package

# Copy the lambda function
cp lambda_function.py lambda-package/

# Install dependencies to the package directory
echo "Installing dependencies..."
pip install pandas==2.0.3 openpyxl==3.1.2 -t lambda-package/ --no-cache-dir

# Create the deployment zip
cd lambda-package
echo "Creating zip file..."
zip -r ../deployment-package.zip . -x "*.pyc" "__pycache__/*" "*.dist-info/*" 

cd ..

# Check the size
echo "Deployment package created!"
ls -lh deployment-package.zip

echo ""
echo "Next steps:"
echo "1. Upload deployment-package.zip to AWS Lambda"
echo "2. Or use: aws lambda update-function-code --function-name leo-peru-process-excel --zip-file fileb://deployment-package.zip"