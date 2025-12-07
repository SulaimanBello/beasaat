# GitHub Actions Deployment Setup

To enable the deployment workflow, you need to configure the following secrets in your GitHub repository.

## Steps

1.  Go to your GitHub repository.
2.  Click on **Settings**.
3.  In the left sidebar, navigate to **Secrets and variables** > **Actions**.
4.  Click on **New repository secret**.
5.  Add the following secrets one by one:

### Required Secrets

| Secret Name       | Description                                                                 | Example Value      |
| ----------------- | --------------------------------------------------------------------------- | ------------------ |
| `HOST`            | The IP address or domain name of your server.                               | `192.168.1.1`      |
| `USERNAME`        | The SSH username to log in to the server.                                   | `root` or `ubuntu` |
| `SSH_PRIVATE_KEY` | The content of your private SSH key. (Must match the public key on server). | `-----BEGIN...`    |
| `PORT`            | The SSH port number (usually 22).                                           | `22`               |

### Notes

-   **SSH Key:** Ensure the private key you paste includes the header `-----BEGIN RSA PRIVATE KEY-----` (or similar) and the footer. The corresponding public key must be added to `~/.ssh/authorized_keys` on your server for the specified `USERNAME`.
-   **Target Directory:** The workflow deploys to `/var/www/beasaat`. Ensure this directory exists on the server and the `USERNAME` has write permissions to it.
