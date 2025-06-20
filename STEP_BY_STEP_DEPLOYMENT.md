# Leo Peru - Complete Step-by-Step Deployment Instructions

## Prerequisites Checklist
- [ ] AWS Account (if not, create at https://aws.amazon.com/free/)
- [ ] GitHub Account (if not, create at https://github.com/)
- [ ] Git installed on your computer
- [ ] Python 3.9 installed locally

---

## Part 1: Prepare Your Code (10 minutes)

### Step 1: Clone/Create GitHub Repository
```bash
# If you haven't already pushed your code to GitHub:
cd /home/qlexqndru/Opusdem/leo-peru
git init
git add .
git commit -m "Initial commit"

# Create a new repository on GitHub.com, then:
git remote add origin https://github.com/YOUR_USERNAME/leo-peru.git
git branch -M main
git push -u origin main
```

### Step 2: Create Deployment Package Locally
```bash
# Create a temporary directory
mkdir lambda-package
cd lambda-package

# Install dependencies
pip install pandas==2.0.3 openpyxl==3.1.2 -t .

# Copy your Lambda function
cp ../lambda_function.py .

# Create the deployment zip
zip -r ../deployment-package.zip . -x "*.pyc" "__pycache__/*"

# Go back to main directory
cd ..

# Check the zip file size (should be under 50MB)
ls -lh deployment-package.zip
```

---

## Part 2: AWS Lambda Setup (15 minutes)

### Step 3: Create Lambda Function
1. **Go to AWS Lambda Console**: https://console.aws.amazon.com/lambda/
2. Click **"Create function"**
3. Fill in:
   - **Function name**: `leo-peru-process-excel`
   - **Runtime**: Python 3.9
   - **Architecture**: x86_64
   - Leave everything else as default
4. Click **"Create function"**

### Step 4: Upload Your Code
1. In the Lambda function page, scroll to **"Code source"**
2. Click **"Upload from"** → **".zip file"**
3. Click **"Upload"** and select your `deployment-package.zip`
4. Click **"Save"**

### Step 5: Configure Lambda Settings
1. Go to **"Configuration"** tab
2. Click **"General configuration"** → **"Edit"**
3. Change:
   - **Timeout**: 1 min (from 3 sec)
   - **Memory**: 512 MB (from 128 MB)
4. Click **"Save"**

### Step 6: Test Lambda Function
1. Go back to **"Code"** tab
2. Click **"Test"** → **"Create new test event"**
3. **Event name**: `test1`
4. Replace the JSON with:
```json
{
  "body": "{\"file\": \"UEsDBAoAA...\", \"filename\": \"test.xlsx\"}"
}
```
5. Click **"Create"**
6. Click **"Test"** (it will fail, but Lambda should be working)

---

## Part 3: API Gateway Setup (15 minutes)

### Step 7: Create API Gateway
1. **Go to API Gateway Console**: https://console.aws.amazon.com/apigateway/
2. Click **"Create API"**
3. Choose **"REST API"** (not private) → **"Build"**
4. Fill in:
   - **API name**: `leo-peru-api`
   - **Endpoint Type**: Regional
5. Click **"Create API"**

### Step 8: Create Resource and Method
1. Click **"Actions"** → **"Create Resource"**
   - **Resource Name**: `process`
   - **Resource Path**: `/process`
   - ✓ **Enable API Gateway CORS**
   - Click **"Create Resource"**

2. With `/process` selected, click **"Actions"** → **"Create Method"**
   - Select **POST** from dropdown
   - Click the checkmark ✓

3. Configure the POST method:
   - **Integration type**: Lambda Function
   - **Use Lambda Proxy integration**: ✓ (check this)
   - **Lambda Region**: us-east-1 (or your region)
   - **Lambda Function**: `leo-peru-process-excel`
   - Click **"Save"**
   - Click **"OK"** on the permission popup

### Step 9: Enable CORS
1. With `/process` selected, click **"Actions"** → **"Enable CORS"**
2. Leave all defaults
3. Click **"Enable CORS and replace existing CORS headers"**
4. Click **"Yes, replace existing values"**

### Step 10: Deploy API
1. Click **"Actions"** → **"Deploy API"**
2. **Deployment stage**: [New Stage]
3. **Stage name**: `prod`
4. Click **"Deploy"**

### Step 11: Copy Your API URL
1. You'll see your **Invoke URL** at the top
2. It looks like: `https://xxxxxxxx.execute-api.us-east-1.amazonaws.com/prod`
3. **COPY THIS URL** - you'll need it next

---

## Part 4: Frontend Setup (10 minutes)

### Step 12: Update Frontend with API URL
1. Open `index.html` in your text editor
2. Find this line (around line 138):
```javascript
const API_ENDPOINT = 'YOUR_API_GATEWAY_URL/process';
```
3. Replace it with your actual URL:
```javascript
const API_ENDPOINT = 'https://xxxxxxxx.execute-api.us-east-1.amazonaws.com/prod/process';
```
4. Save the file

### Step 13: Commit and Push Changes
```bash
git add index.html
git commit -m "Add API Gateway URL"
git push origin main
```

### Step 14: Enable GitHub Pages
1. Go to your GitHub repository
2. Click **"Settings"** (in the repo, not your profile)
3. Scroll down to **"Pages"** section
4. Under **"Source"**:
   - Select **"Deploy from a branch"**
   - Branch: **main**
   - Folder: **/ (root)**
5. Click **"Save"**
6. Wait 2-3 minutes for deployment

### Step 15: Test Your Application
1. Visit: `https://YOUR_GITHUB_USERNAME.github.io/leo-peru/`
2. You should see the upload interface
3. Try uploading one of your test Excel files
4. You should get the processed file back!

---

## Part 5: Setup Automated Deployment (Optional - 10 minutes)

### Step 16: Create AWS Access Keys
1. Go to **IAM Console**: https://console.aws.amazon.com/iam/
2. Click **"Users"** → **"Add users"**
3. **User name**: `leo-peru-deploy`
4. Click **"Next"**
5. Select **"Attach policies directly"**
6. Search and select: `AWSLambda_FullAccess`
7. Click **"Next"** → **"Create user"**

### Step 17: Create Access Key
1. Click on the user `leo-peru-deploy`
2. Go to **"Security credentials"** tab
3. Under **"Access keys"**, click **"Create access key"**
4. Select **"Command Line Interface (CLI)"**
5. Check the confirmation box
6. Click **"Next"** → **"Create access key"**
7. **SAVE THESE CREDENTIALS** (you won't see them again):
   - Access key ID
   - Secret access key

### Step 18: Add Secrets to GitHub
1. Go to your GitHub repository
2. Click **"Settings"** → **"Secrets and variables"** → **"Actions"**
3. Click **"New repository secret"**
4. Add two secrets:
   - **Name**: `AWS_ACCESS_KEY_ID`
     **Value**: (your access key ID)
   - **Name**: `AWS_SECRET_ACCESS_KEY`
     **Value**: (your secret access key)

### Step 19: Test Automated Deployment
1. Make a small change to `lambda_function.py` (like adding a comment)
2. Commit and push:
```bash
git add lambda_function.py
git commit -m "Test automated deployment"
git push origin main
```
3. Go to **"Actions"** tab in GitHub to see deployment progress

---

## Troubleshooting

### If Upload Fails:
1. **Check browser console** (F12) for errors
2. **Verify API URL** is correct in index.html
3. **Check Lambda logs**:
   - Go to Lambda → Monitoring → View logs in CloudWatch

### If Processing Fails:
1. **Check file size** (must be under 6MB for API Gateway)
2. **Verify Excel format** matches expected structure
3. **Increase Lambda timeout** if needed

### Common Issues:
- **CORS error**: Re-enable CORS in API Gateway and redeploy
- **403 Forbidden**: Check API Gateway deployment
- **502 Bad Gateway**: Check Lambda function errors
- **Timeout**: Increase Lambda timeout (max 15 minutes)

---

## Testing Checklist
- [ ] Frontend loads at GitHub Pages URL
- [ ] Can select/drag Excel file
- [ ] Upload shows progress
- [ ] Processed file downloads successfully
- [ ] File contains expected analysis
- [ ] Charts are properly generated

---

## Maintenance

### To Update Processing Logic:
1. Edit `lambda_function.py`
2. Either:
   - **Manual**: Re-create zip and upload via AWS Console
   - **Automatic**: Push to GitHub (if CI/CD is set up)

### To Update Frontend:
1. Edit `index.html`
2. Push to GitHub
3. Changes appear in ~2 minutes

### Monthly Cost Monitoring:
1. Go to **AWS Billing Dashboard**
2. You should see $0.00 if under free tier limits
3. Set up billing alerts just in case

---

## Success! 🎉
Your Leo Peru application is now live and accessible from anywhere!

**Your URLs**:
- Frontend: `https://YOUR_GITHUB_USERNAME.github.io/leo-peru/`
- API: `https://xxxxxxxx.execute-api.us-east-1.amazonaws.com/prod/process`

**Free Tier Limits**:
- Lambda: 1,000,000 requests/month
- API Gateway: 1,000,000 requests/month
- Total Cost: $0.00