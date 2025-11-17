# Quick Docker Deployment Guide

## Prerequisites

- Docker installed and running
- Firebase web app configured

## Step 1: Configure Firebase for Web

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Click the **Web icon** (`</>`) to add a web app
4. Copy the Firebase configuration

5. Update `lib/utils/firebase_config.dart`:
   ```dart
   apiKey: 'YOUR_WEB_API_KEY',
   appId: 'YOUR_WEB_APP_ID',
   messagingSenderId: 'YOUR_SENDER_ID',
   projectId: 'YOUR_PROJECT_ID',
   authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
   storageBucket: 'YOUR_PROJECT_ID.appspot.com',
   ```

## Step 2: Deploy

### Option A: Using Scripts (Easiest)

**Windows:**
```bash
deploy.bat run
```

**Linux/Mac:**
```bash
chmod +x deploy.sh
./deploy.sh run
```

### Option B: Using Docker Compose

```bash
docker-compose up -d --build
```

### Option C: Using Docker Commands

```bash
# Build the image
docker build -t engitrack:latest .

# Run the container
docker run -d -p 8080:80 --name engitrack-web engitrack:latest
```

## Step 3: Access the App

Open your browser and navigate to:
```
http://localhost:8080
```

## Useful Commands

### View Logs
```bash
# Docker Compose
docker-compose logs -f

# Docker
docker logs -f engitrack-web
```

### Stop the App
```bash
# Docker Compose
docker-compose down

# Docker
docker stop engitrack-web
docker rm engitrack-web
```

### Restart the App
```bash
# Windows
deploy.bat restart

# Linux/Mac
./deploy.sh restart
```

## Troubleshooting

### Build Fails
- Make sure Docker is running
- Check that all files are present
- Try: `docker build --no-cache -t engitrack:latest .`

### App Not Loading
- Check logs: `docker logs engitrack-web`
- Verify Firebase configuration
- Check browser console for errors

### Port Already in Use
- Change port in `docker-compose.yml`: `"3000:80"` instead of `"8080:80"`
- Or stop the service using port 8080

## Production Deployment

For production deployment to cloud platforms, see [DOCKER_DEPLOYMENT.md](DOCKER_DEPLOYMENT.md) for detailed instructions on:
- Google Cloud Run
- AWS ECS/Fargate
- Azure Container Instances
- DigitalOcean App Platform
- VPS/Server deployment

