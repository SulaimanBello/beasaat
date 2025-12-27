# EasyPanel Automatic Deployment Guide

This guide explains how to set up automatic deployment for Beasaat Technologies Global website on **EasyPanel v2.23.0**.

## Prerequisites

- An EasyPanel v2.23.0 server up and running
- GitHub repository with the project code
- Domain name (optional but recommended)

## Deployment Architecture

The application is containerized using Docker with:
- **Base Image**: nginx:alpine (lightweight web server)
- **Port**: 80 (HTTP)
- **Auto-deployment**: Triggered by GitHub pushes

---

## Step 1: Access EasyPanel Dashboard

1. Log in to your EasyPanel dashboard at `https://your-server-ip:3000` or your configured domain
2. Navigate to **Projects** section

## Step 2: Create a New Project

1. Click **"Create Project"**
2. Enter project details:
   - **Name**: `beasaat` (or your preferred name)
   - **Description**: Beasaat Technologies Global Website

## Step 3: Add a New Service

1. Inside your project, click **"Add Service"**
2. Select **"App"** as the service type
3. Choose **"GitHub"** as the source

## Step 4: Configure GitHub Integration

### Option A: Connect GitHub Repository

1. Click **"Connect GitHub"**
2. Authorize EasyPanel to access your GitHub account
3. Select the repository: `SulaimanBello/beasaat` (or your repository)
4. Choose the branch: `main`

### Option B: Use GitHub Token (Alternative)

If you prefer using a personal access token:

1. Go to GitHub → Settings → Developer settings → Personal access tokens
2. Generate a new token with `repo` scope
3. In EasyPanel, enter:
   - **Repository URL**: `https://github.com/SulaimanBello/beasaat`
   - **Token**: Your GitHub personal access token
   - **Branch**: `main`

## Step 5: Configure Build Settings

In the service configuration:

### General Settings
- **Name**: `beasaat-web`
- **Source**: GitHub repository
- **Branch**: `main`
- **Build Method**: Dockerfile

### Build Configuration
- **Dockerfile Path**: `./Dockerfile` (default)
- **Build Context**: `.` (root directory)

### Port Configuration
- **Container Port**: `80`
- **Protocol**: HTTP

## Step 6: Configure Domain (Optional)

1. In the service settings, navigate to **"Domains"**
2. Click **"Add Domain"**
3. Enter your domain name (e.g., `beasaat.com` or `www.beasaat.com`)
4. EasyPanel will automatically:
   - Configure Traefik reverse proxy
   - Issue SSL certificate via Let's Encrypt
   - Set up HTTPS redirection

**Note**: Make sure your domain's DNS A record points to your EasyPanel server's IP address.

## Step 7: Enable Automatic Deployment

1. In the service settings, navigate to **"Deploy"** section
2. Enable **"Auto Deploy"** toggle
3. This will:
   - Create a webhook in your GitHub repository
   - Trigger automatic builds on every push to the main branch
   - Deploy the new version automatically

### Manual Webhook Setup (if needed)

If automatic webhook creation fails, set it up manually:

1. In your GitHub repository, go to **Settings → Webhooks → Add webhook**
2. Configure webhook:
   - **Payload URL**: `https://your-easypanel-domain/webhooks/github/your-project-id`
   - **Content type**: `application/json`
   - **Secret**: (get from EasyPanel webhook settings)
   - **Events**: Select "Just the push event"
   - **Active**: ✓ (checked)

## Step 8: Deploy the Application

1. Click **"Deploy"** button in EasyPanel
2. EasyPanel will:
   - Pull the latest code from GitHub
   - Build the Docker image using the Dockerfile
   - Start the container
   - Configure reverse proxy and SSL (if domain configured)

### Monitor Deployment

- View real-time logs in the **"Logs"** tab
- Check deployment status in the **"Deploy"** section
- Verify the application is running in the **"Services"** overview

## Step 9: Verify Deployment

1. Open your browser and navigate to:
   - Your domain (if configured): `https://your-domain.com`
   - Or server IP: `http://your-server-ip:port`

2. You should see the Beasaat Technologies Global landing page

## Automatic Deployment Workflow

Once configured, the deployment workflow is:

```
Developer pushes to GitHub
        ↓
GitHub sends webhook to EasyPanel
        ↓
EasyPanel receives webhook
        ↓
Pulls latest code from main branch
        ↓
Builds new Docker image
        ↓
Stops old container (if running)
        ↓
Starts new container with updated code
        ↓
Zero-downtime deployment complete!
```

---

## Environment Variables (if needed)

To add environment variables:

1. Go to service settings → **"Environment"**
2. Add variables in key-value format:
   ```
   TZ=Africa/Lagos
   NODE_ENV=production
   ```

---

## Troubleshooting

### Build Fails

1. Check build logs in EasyPanel dashboard
2. Verify Dockerfile syntax
3. Ensure all required files are in the repository
4. Check that nginx.conf is present

### Webhook Not Triggering

1. Verify webhook is created in GitHub repository settings
2. Check webhook delivery history in GitHub
3. Ensure EasyPanel server is accessible from the internet
4. Verify firewall rules allow incoming webhooks

### Container Crashes

1. Check container logs in EasyPanel
2. Verify port 80 is not already in use
3. Check nginx configuration syntax
4. Ensure all static files exist

### SSL/HTTPS Issues

1. Verify DNS records point to correct IP
2. Check domain configuration in EasyPanel
3. Wait a few minutes for Let's Encrypt certificate generation
4. Check Traefik logs if issues persist

---

## Updating the Application

### Automatic Updates (Recommended)

Simply push changes to your GitHub repository's main branch:

```bash
git add .
git commit -m "Update website content"
git push origin main
```

EasyPanel will automatically:
- Detect the push via webhook
- Rebuild the Docker image
- Deploy the new version

### Manual Updates

If you need to manually trigger a deployment:

1. Go to EasyPanel dashboard
2. Navigate to your service
3. Click the **"Deploy"** button

---

## Rollback to Previous Version

If a deployment introduces issues:

1. Go to **"Deploy"** section in EasyPanel
2. View deployment history
3. Click **"Rollback"** on a previous successful deployment

---

## Advanced Configuration

### Custom Nginx Configuration

To modify nginx settings, edit [nginx.conf](nginx.conf) and push changes to GitHub.

### Multi-stage Builds

For more complex applications, consider using multi-stage Docker builds to optimize image size.

### Health Checks

Add health check to docker-compose.yml:

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

### Resource Limits

Configure resource limits in EasyPanel:
- **CPU**: 0.5 cores (adjust as needed)
- **Memory**: 256MB (sufficient for static site)

---

## Monitoring and Maintenance

### Logs

- Access logs in EasyPanel dashboard → **Logs** tab
- Filter by time range or search for specific events

### Metrics

Monitor in EasyPanel:
- CPU usage
- Memory usage
- Network traffic
- Request count

### Backup Strategy

1. GitHub repository serves as code backup
2. EasyPanel handles container backups
3. Consider backing up EasyPanel configuration periodically

---

## Security Best Practices

1. **Keep EasyPanel Updated**: Regularly update to the latest version
2. **Use Strong Passwords**: For EasyPanel and GitHub accounts
3. **Enable 2FA**: On GitHub account
4. **Review Webhook Secrets**: Use secure, random webhook secrets
5. **Monitor Access Logs**: Regularly check for suspicious activity
6. **HTTPS Only**: Always use SSL/TLS for production domains

---

## Support and Resources

- **EasyPanel Documentation**: https://easypanel.io/docs
- **GitHub Repository**: https://github.com/SulaimanBello/beasaat
- **Docker Documentation**: https://docs.docker.com
- **Nginx Documentation**: https://nginx.org/en/docs

---

## Summary

You now have a fully automated deployment pipeline:

✅ Code pushed to GitHub
✅ Automatic webhook triggers build
✅ Docker image built with latest code
✅ New container deployed automatically
✅ Zero-downtime deployments
✅ SSL/HTTPS configured automatically

**Deployment is now as simple as:**
```bash
git push origin main
```

Enjoy your automated deployment! 🚀
