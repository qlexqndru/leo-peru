# Leo Peru - Deployment Guide

## Simple AWS Lambda Deployment (Free Tier)

### Prerequisites
- AWS Account (free tier eligible)
- GitHub Account (for hosting frontend)
- AWS CLI installed locally

### Architecture
```
GitHub Pages (Frontend) → API Gateway → Lambda → Response
```

### Step 1: Create Lambda Function

1. Go to AWS Lambda Console
2. Click "Create function"
3. Choose:
   - Function name: `leo-peru-process-excel`
   - Runtime: Python 3.9
   - Architecture: x86_64

### Step 2: Create Deployment Package

```bash
# Create a directory for dependencies
mkdir package
cd package

# Install dependencies
pip install pandas openpyxl -t .

# Copy your lambda function
cp ../lambda_function.py .

# Create zip file
zip -r ../deployment.zip .
```

### Step 3: Upload to Lambda

1. In Lambda console, upload the `deployment.zip` file
2. Set handler to: `lambda_function.lambda_handler`
3. Increase timeout to 30 seconds
4. Increase memory to 512 MB

### Step 4: Create API Gateway

1. Go to API Gateway Console
2. Create REST API
3. Create Resource: `/process`
4. Create Method: POST
5. Integration type: Lambda Function
6. Select your Lambda function
7. Deploy API to "prod" stage
8. Copy the invoke URL

### Step 5: Update Frontend

1. Edit `index.html`
2. Replace `YOUR_API_GATEWAY_URL` with your actual API Gateway URL
3. Commit and push to GitHub

### Step 6: Enable GitHub Pages

1. Go to your repo Settings → Pages
2. Source: Deploy from branch
3. Branch: main, folder: / (root)
4. Save

### Step 7: Set up GitHub Secrets

For automated deployment, add these secrets to your GitHub repo:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

### Usage

1. Visit: `https://[your-github-username].github.io/leo-peru/`
2. Upload Excel file
3. Download processed file

### Costs (Free Tier)

- Lambda: 1M requests/month free
- API Gateway: 1M requests/month free  
- GitHub Pages: Free
- Total monthly cost: $0

### Manual Updates

To update the Lambda function manually:
```bash
# Make changes to lambda_function.py
# Recreate deployment package
# Upload via AWS Console or CLI:
aws lambda update-function-code \
  --function-name leo-peru-process-excel \
  --zip-file fileb://deployment.zip
```

### Troubleshooting

1. **CORS errors**: Make sure API Gateway has CORS enabled
2. **Timeout errors**: Increase Lambda timeout (max 15 min)
3. **Memory errors**: Increase Lambda memory (max 10GB)
4. **File size limits**: API Gateway has 10MB limit for payloads