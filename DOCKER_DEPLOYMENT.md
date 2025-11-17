# Docker Deployment Guide for EngiTrack

This guide explains how to deploy EngiTrack as a Flutter web application using Docker.

## Prerequisites

- Docker installed (version 20.10 or higher)
- Docker Compose installed (version 2.0 or higher)
- Flutter SDK (for local testing, not required for Docker build)
- Firebase project configured for web

## Important Notes

⚠️ **Before deploying, ensure:**
1. Firebase is configured for web platform
2. Firebase web configuration is added to your project
3. All environment variables are set correctly

## Quick Start

### Option 1: Using Docker Compose (Recommended)

1. **Build and run:**
   ```bash
   docker-compose up -d --build
   ```

2. **Access the app:**
   - Open browser: `http://localhost:8080`

3. **View logs:**
   ```bash
   docker-compose logs -f
   ```

4. **Stop the app:**
   ```bash
   docker-compose down
   ```

### Option 2: Using Docker directly

1. **Build the image:**
   ```bash
   docker build -t engitrack:latest .
   ```

2. **Run the container:**
   ```bash
   docker run -d -p 8080:80 --name engitrack-web engitrack:latest
   ```

3. **Access the app:**
   - Open browser: `http://localhost:8080`

4. **Stop the container:**
   ```bash
   docker stop engitrack-web
   docker rm engitrack-web
   ```

## Firebase Web Configuration

Before building the Docker image, you need to configure Firebase for web:

### 1. Add Web App to Firebase

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Click the **Web icon** (`</>`) to add a web app
4. Register your app with a nickname
5. Copy the Firebase configuration

### 2. Add Firebase Configuration to Flutter

Create or update `lib/firebase_options.dart`:

```dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );

  // Add android and ios configs if needed
  static const FirebaseOptions android = FirebaseOptions(
    // ... your Android config
  );

  static const FirebaseOptions ios = FirebaseOptions(
    // ... your iOS config
  );
}
```

### 3. Update main.dart

Update `lib/main.dart` to use Firebase options:

```dart
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // ... rest of initialization
}
```

## Building for Production

### 1. Build the Docker Image

```bash
docker build -t engitrack:latest .
```

### 2. Test Locally

```bash
docker run -p 8080:80 engitrack:latest
```

### 3. Tag for Registry (if pushing to registry)

```bash
docker tag engitrack:latest your-registry/engitrack:latest
docker push your-registry/engitrack:latest
```

## Deployment Options

### Deploy to Cloud Platforms

#### Google Cloud Run

```bash
# Build and push to GCR
gcloud builds submit --tag gcr.io/YOUR_PROJECT_ID/engitrack

# Deploy to Cloud Run
gcloud run deploy engitrack \
  --image gcr.io/YOUR_PROJECT_ID/engitrack \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

#### AWS ECS/Fargate

1. Build and push to ECR:
   ```bash
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com
   docker build -t engitrack .
   docker tag engitrack:latest YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/engitrack:latest
   docker push YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/engitrack:latest
   ```

2. Create ECS task definition and service

#### Azure Container Instances

```bash
# Build and push to ACR
az acr build --registry YOUR_REGISTRY --image engitrack:latest .

# Deploy
az container create \
  --resource-group YOUR_RESOURCE_GROUP \
  --name engitrack \
  --image YOUR_REGISTRY.azurecr.io/engitrack:latest \
  --dns-name-label engitrack \
  --ports 80
```

#### DigitalOcean App Platform

1. Connect your repository
2. Use Dockerfile for build
3. Set port to 80
4. Deploy

### Deploy to VPS/Server

1. **SSH into your server:**
   ```bash
   ssh user@your-server.com
   ```

2. **Clone repository:**
   ```bash
   git clone YOUR_REPO_URL
   cd engitrack
   ```

3. **Build and run:**
   ```bash
   docker-compose up -d --build
   ```

4. **Set up reverse proxy (Nginx):**
   ```nginx
   server {
       listen 80;
       server_name your-domain.com;

       location / {
           proxy_pass http://localhost:8080;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
   }
   ```

5. **Set up SSL with Let's Encrypt:**
   ```bash
   sudo certbot --nginx -d your-domain.com
   ```

## Environment Variables

If you need to pass environment variables, update `docker-compose.yml`:

```yaml
services:
  engitrack-web:
    # ... other config
    environment:
      - FIREBASE_API_KEY=${FIREBASE_API_KEY}
      - FIREBASE_PROJECT_ID=${FIREBASE_PROJECT_ID}
      # ... other vars
```

Create a `.env` file:
```env
FIREBASE_API_KEY=your_api_key
FIREBASE_PROJECT_ID=your_project_id
```

## Customization

### Change Port

Edit `docker-compose.yml`:
```yaml
ports:
  - "3000:80"  # Change 8080 to your desired port
```

### Custom Nginx Configuration

Modify `nginx.conf` and rebuild:
```bash
docker-compose build --no-cache
docker-compose up -d
```

### Multi-stage Build Optimization

The Dockerfile uses multi-stage builds:
- **Stage 1**: Build Flutter web app
- **Stage 2**: Serve with nginx (lightweight)

This results in a smaller final image (~50MB vs ~500MB+).

## Troubleshooting

### Build Fails

1. **Check Flutter version:**
   ```bash
   docker run --rm ghcr.io/cirruslabs/flutter:stable flutter --version
   ```

2. **Clear Docker cache:**
   ```bash
   docker builder prune -a
   ```

3. **Rebuild without cache:**
   ```bash
   docker build --no-cache -t engitrack:latest .
   ```

### App Not Loading

1. **Check container logs:**
   ```bash
   docker logs engitrack-web
   ```

2. **Check nginx configuration:**
   ```bash
   docker exec engitrack-web nginx -t
   ```

3. **Verify Firebase configuration:**
   - Check browser console for Firebase errors
   - Ensure Firebase web app is configured
   - Verify API keys are correct

### Performance Issues

1. **Enable gzip in nginx** (already enabled in nginx.conf)
2. **Use CDN for static assets**
3. **Enable HTTP/2**
4. **Optimize Flutter web build:**
   ```bash
   flutter build web --release --web-renderer canvaskit
   ```

## Security Considerations

1. **Firebase Security Rules:**
   - Configure Firestore security rules
   - Set up Authentication restrictions
   - Enable App Check for web

2. **HTTPS:**
   - Always use HTTPS in production
   - Set up SSL certificates
   - Use Let's Encrypt for free SSL

3. **Headers:**
   - Security headers are configured in nginx.conf
   - Consider adding CSP (Content Security Policy)

4. **Environment Variables:**
   - Never commit API keys
   - Use secrets management
   - Rotate keys regularly

## Monitoring

### Health Check

The container includes a health check endpoint:
```bash
curl http://localhost:8080/health
```

### Logs

View logs:
```bash
# Docker Compose
docker-compose logs -f engitrack-web

# Docker
docker logs -f engitrack-web
```

## Scaling

### Horizontal Scaling

For multiple instances, use a load balancer:

```yaml
version: '3.8'
services:
  engitrack-web:
    # ... config
    deploy:
      replicas: 3
```

### Load Balancer Example (Nginx)

```nginx
upstream engitrack {
    least_conn;
    server engitrack-web-1:80;
    server engitrack-web-2:80;
    server engitrack-web-3:80;
}
```

## Backup and Recovery

1. **Backup Firebase data:**
   - Use Firebase export functionality
   - Regular automated backups

2. **Backup Docker volumes** (if using volumes):
   ```bash
   docker run --rm -v engitrack_data:/data -v $(pwd):/backup alpine tar czf /backup/backup.tar.gz /data
   ```

## Maintenance

### Update App

```bash
# Pull latest code
git pull

# Rebuild and restart
docker-compose up -d --build
```

### Clean Up

```bash
# Remove old images
docker image prune -a

# Remove stopped containers
docker container prune
```

## Support

For issues:
1. Check container logs
2. Verify Firebase configuration
3. Check browser console for errors
4. Review nginx logs

