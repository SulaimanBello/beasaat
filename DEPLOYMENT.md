# Deployment Guide - Nginx

This guide outlines how to deploy the Beasaat Technologies Global landing page using Nginx on a Linux server (e.g., Ubuntu/Debian).

## Prerequisites

- A Linux server with root or sudo access.
- Nginx installed (`sudo apt update && sudo apt install nginx`).
- Domain name pointed to your server's IP address (optional but recommended).

## 1. Prepare the Project Files

Upload your project files (`index.html`, `styles.css`, `script.js`, etc.) to the server. A common location is `/var/www/beasaat`.

```bash
# Example: Create directory and set permissions
sudo mkdir -p /var/www/beasaat
sudo chown -R $USER:$USER /var/www/beasaat
# Copy your files to this directory
```

## 2. Nginx Configuration

Create a new Nginx server block configuration file.

**File:** `/etc/nginx/sites-available/beasaat`

```nginx
server {
    listen 80;
    listen [::]:80;

    server_name example.com www.example.com; # Replace with your actual domain or IP

    root /var/www/beasaat;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    # Optional: Cache static assets for better performance
    location ~* \.(css|js|jpg|jpeg|png|gif|ico|svg)$ {
        expires 30d;
        add_header Cache-Control "public, no-transform";
    }

    # Security headers (Recommended)
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";
}
```

## 3. Enable the Site

Link the configuration file to the `sites-enabled` directory.

```bash
sudo ln -s /etc/nginx/sites-available/beasaat /etc/nginx/sites-enabled/
```

## 4. Test and Restart Nginx

Check for syntax errors and restart Nginx to apply changes.

```bash
# Test configuration
sudo nginx -t

# If successful, restart Nginx
sudo systemctl restart nginx
```

## 5. (Optional) SSL Setup with Certbot

Secure your site with HTTPS using Let's Encrypt.

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d example.com -d www.example.com
```

## 6. Automated Deployment via GitHub Actions

This repository includes a GitHub Actions workflow (`.github/workflows/deploy.yml`) that automatically deploys changes to the production server whenever code is pushed to the `main` branch.

### Setup

To enable automated deployment, you must configure the following **Secrets** in your GitHub repository settings (`Settings` > `Secrets and variables` > `Actions`):

| Secret Name | Description |
| :--- | :--- |
| `HOST` | The IP address or domain name of your server. |
| `USERNAME` | The SSH username to log in as (e.g., `ubuntu` or `root`). |
| `SSH_PRIVATE_KEY` | The content of your private SSH key. (The public key must be added to `~/.ssh/authorized_keys` on the server for the corresponding user). |
| `PORT` | (Optional) The SSH port, defaults to `22`. |

### Workflow Behavior

1.  **Trigger**: Pushes to the `main` branch.
2.  **Action**: Uses `scp` to copy the project files to `/var/www/beasaat`.
3.  **Exclusions**: Excludes development files like `.git`, `.github`, and documentation.
