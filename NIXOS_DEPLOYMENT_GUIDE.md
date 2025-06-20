# Leo Peru - NixOS Deployment Guide

## Prerequisites
- [x] NixOS with nix-shell (you have this)
- [x] Git (you have this)
- [ ] AWS Account (create at https://aws.amazon.com/free/)
- [ ] GitHub Account (create at https://github.com/)

---

## Part 1: Setup Development Environment (2 minutes)

### Step 1: Enter Nix Shell
```bash
cd /home/qlexqndru/Opusdem/leo-peru
nix-shell
```

You'll see:
```
Leo Peru Development Environment
--------------------------------
Available commands:
  python generate_analysis.py - Run local analysis
  ./deploy.sh - Create Lambda deployment package
  aws - AWS CLI for deployment
```

---

## Part 2: Prepare Your Code (5 minutes)

### Step 2: Initialize Git Repository (if needed)
```bash
# If not already a git repo:
git init
git add .
git commit -m "Initial commit"
```

### Step 3: Create GitHub Repository
1. Go to https://github.com/new
2. Repository name: `leo-peru`
3. Public repository
4. DON'T initialize with README
5. Click "Create repository"

### Step 4: Push to GitHub
```bash
# Replace YOUR_USERNAME with your GitHub username
git remote add origin https://github.com/YOUR_USERNAME/leo-peru.git
git branch -M main
git push -u origin main
```

### Step 5: Create Lambda Deployment Package
```bash
# Inside nix-shell
./deploy.sh
```

This creates `deployment-package.zip` with all dependencies.

---

## Part 3: AWS Lambda Setup (10 minutes)

### Step 6: Create Lambda Function
1. Go to https://console.aws.amazon.com/lambda/
2. Click **"Create function"**
3. Settings:
   - Function name: `leo-peru-process-excel`
   - Runtime: `Python 3.9`
   - Architecture: `x86_64`
4. Click **"Create function"**

### Step 7: Upload Code
1. In Lambda console, under "Code source"
2. Click **"Upload from"** → **".zip file"**
3. Upload `deployment-package.zip`
4. Click **"Save"**

### Step 8: Configure Lambda
1. Go to **"Configuration"** tab
2. **"General configuration"** → **"Edit"**
   - Timeout: `1 min`
   - Memory: `512 MB`
3. Click **"Save"**

---

## Part 4: API Gateway Setup (10 minutes)

### Step 9: Create API
1. Go to https://console.aws.amazon.com/apigateway/
2. Click **"Create API"**
3. Choose **"REST API"** → **"Build"**
4. Settings:
   - API name: `leo-peru-api`
   - Endpoint Type: `Regional`
5. Click **"Create API"**

### Step 10: Create Endpoint
1. Click **"Actions"** → **"Create Resource"**
   - Resource Name: `process`
   - Resource Path: `/process`
   - ✓ Enable API Gateway CORS
   - Click **"Create Resource"**

2. Select `/process`, click **"Actions"** → **"Create Method"**
   - Choose **POST**
   - Click ✓

3. Setup POST:
   - Integration type: `Lambda Function`
   - ✓ Use Lambda Proxy integration
   - Lambda Function: `leo-peru-process-excel`
   - Click **"Save"** → **"OK"**

### Step 11: Deploy API
1. Click **"Actions"** → **"Deploy API"**
2. Deployment stage: `[New Stage]`
3. Stage name: `prod`
4. Click **"Deploy"**
5. **COPY the Invoke URL** (like `https://xxxxxx.execute-api.us-east-1.amazonaws.com/prod`)

---

## Part 5: Frontend Deployment (5 minutes)

### Step 12: Update Frontend
```bash
# Still in nix-shell
# Edit index.html to add your API URL
nano index.html
```

Find line ~138:
```javascript
const API_ENDPOINT = 'YOUR_API_GATEWAY_URL/process';
```

Replace with your URL:
```javascript
const API_ENDPOINT = 'https://xxxxxx.execute-api.us-east-1.amazonaws.com/prod/process';
```

Save (Ctrl+X, Y, Enter)

### Step 13: Commit and Push
```bash
git add index.html
git commit -m "Add API Gateway URL"
git push
```

### Step 14: Enable GitHub Pages
1. Go to your GitHub repo → **Settings** → **Pages**
2. Source: `Deploy from a branch`
3. Branch: `main`, folder: `/ (root)`
4. Click **Save**

### Step 15: Test
After 2-3 minutes, visit:
`https://YOUR_GITHUB_USERNAME.github.io/leo-peru/`

---

## Part 6: Setup AWS CLI (Optional - for updates)

### Step 16: Configure AWS CLI
```bash
# In nix-shell
aws configure
```

Enter:
- AWS Access Key ID: (from AWS IAM)
- AWS Secret Access Key: (from AWS IAM)
- Default region: `us-east-1`
- Default output format: `json`

### Step 17: Deploy Updates via CLI
```bash
# After making changes to lambda_function.py
./deploy.sh

# Deploy to AWS
aws lambda update-function-code \
  --function-name leo-peru-process-excel \
  --zip-file fileb://deployment-package.zip
```

---

## Quick Commands Reference

### In Nix Shell:
```bash
# Enter environment
nix-shell

# Test locally
python generate_analysis.py "PACKING LIST 14.xlsx"

# Create deployment package
./deploy.sh

# Deploy to AWS (after configuring)
aws lambda update-function-code \
  --function-name leo-peru-process-excel \
  --zip-file fileb://deployment-package.zip
```

### Git Commands:
```bash
# Check status
git status

# Commit changes
git add -A
git commit -m "Update message"
git push
```

---

## Troubleshooting

### Nix Shell Issues:
```bash
# If shell.nix changed, reload:
exit
nix-shell
```

### Lambda Package Too Large:
```bash
# Check size
ls -lh deployment-package.zip

# If > 50MB, might need to use Lambda Layers
```

### CORS Errors:
1. In API Gateway, select `/process`
2. Actions → Enable CORS
3. Deploy API again

---

## Success! 🎉

Your app is now live at:
`https://YOUR_GITHUB_USERNAME.github.io/leo-peru/`

Total cost: **$0** (within AWS free tier)