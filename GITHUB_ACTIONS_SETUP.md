# GitHub Actions Deployment Setup

To enable the automated deployment workflow, you need to configure specific secrets in your GitHub repository. This guide provides detailed steps on generating keys, obtaining server details, and saving them as secrets.

## 1. Generate an SSH Key Pair

You need a dedicated SSH key pair for GitHub Actions to authenticate with your server. **Do not use your personal SSH key.**

1.  Open a terminal on your local computer.
2.  Run the following command to generate a new key (press Enter to accept the default file location, but **give it a unique name** like `github_deploy_key` to avoid overwriting your personal keys):

    ```bash
    ssh-keygen -t rsa -b 4096 -C "github-actions-deploy" -f ~/.ssh/github_deploy_key
    ```

3.  **Do not set a passphrase.** (Just press Enter twice when prompted). GitHub Actions cannot enter a password for you.

## 2. Add the Public Key to Your Server

The server needs to trust the key you just generated.

1.  Copy the content of the **public** key (`.pub` extension):

    ```bash
    cat ~/.ssh/github_deploy_key.pub
    ```

2.  Log in to your server (replace `user` and `your-server-ip` with your actual details):

    ```bash
    ssh user@your-server-ip
    ```

3.  Add the public key to the `authorized_keys` file:

    ```bash
    # Create the directory if it doesn't exist
    mkdir -p ~/.ssh

    # Append the key (paste the content you copied in step 1)
    echo "PASTE_YOUR_PUBLIC_KEY_HERE" >> ~/.ssh/authorized_keys

    # Set correct permissions
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/authorized_keys
    ```

## 3. Configure GitHub Secrets

1.  Go to your GitHub repository.
2.  Click on **Settings**.
3.  In the left sidebar, navigate to **Secrets and variables** > **Actions**.
4.  Click on **New repository secret**.
5.  Add the following secrets one by one:

### Required Secrets

| Secret Name       | Description                                                                                             | Example Value                                  |
| ----------------- | ------------------------------------------------------------------------------------------------------- | ---------------------------------------------- |
| `HOST`            | The public IP address OR domain name of your server.                                                    | `203.0.113.45` OR `example.com`                |
| `USERNAME`        | The SSH username you logged in with in Step 2.                                                          | `root`, `ubuntu`, or `admin`                   |
| `SSH_PRIVATE_KEY` | The **private** key content. Run `cat ~/.ssh/github_deploy_key` on your local machine and copy *all* of it. | `-----BEGIN RSA PRIVATE KEY----- ...`          |
| `PORT`            | The SSH port number.                                                                                    | `22` (Default) or `2222` (if custom)           |

### Important Notes

-   **Private Key Format:** When copying `SSH_PRIVATE_KEY`, ensure you include the header (`-----BEGIN RSA PRIVATE KEY-----`) and the footer (`-----END RSA PRIVATE KEY-----`).
-   **Target Directory:** The workflow deploys to `/var/www/beasaat`.
    -   Ensure this directory exists on the server: `sudo mkdir -p /var/www/beasaat`
    -   Ensure your `USERNAME` has write permissions: `sudo chown -R $USER:$USER /var/www/beasaat`
