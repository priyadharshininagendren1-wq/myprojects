# Smart Auto-Deployment System (Beginner-friendly DevOps Project)

This project is a **complete beginner-friendly** DevOps setup using:
- **Flask (Python)**
- **Docker**
- **GitHub Actions** (CI/CD)
- **AWS EC2** (deployment target)
- **Git** (push to trigger auto-deploy)

✅ **Goal**: Whenever you push code to GitHub, GitHub Actions will automatically:
1. Build a Docker image
2. Deploy the application to your **AWS EC2** server
3. Run it using Docker on Linux

> Note: This setup deploys by SSH-ing into EC2 and running Docker commands. Docker Hub is optional in this basic version.

---

## 0) What you will create

Inside `SmartAutoDeploymentSystem/` you will have:
- `app.py` - Flask app
- `requirements.txt`
- `Dockerfile`
- `.gitignore`
- `.github/workflows/deploy.yml` - GitHub Actions CI/CD

---

## 1) Folder structure

After everything is created, your project will look like:

```
SmartAutoDeploymentSystem/
├─ app.py
├─ requirements.txt
├─ Dockerfile
├─ .gitignore
├─ README.md
└─ .github/
   └─ workflows/
      └─ deploy.yml
```

---

## 2) Create the project folder

In **VSCode terminal** (or Windows Command Prompt), run:

```bash
mkdir SmartAutoDeploymentSystem
cd SmartAutoDeploymentSystem
```

(Commands to type are shown in code blocks.)

---

## 3) Create files

Files in this project:
- `app.py` (Flask web app)
- `requirements.txt` (Python dependencies)
- `Dockerfile` (container build rules)
- `.gitignore`
- `.github/workflows/deploy.yml` (GitHub Actions CI/CD)


---

## 4) Running locally (optional)

### 4.1 Install dependencies

```bash
pip install -r requirements.txt
```

### 4.2 Start Flask

```bash
python app.py
```

Then open:
- http://127.0.0.1:5000

---

## 5) Docker commands (what they do)

### Build an image

```bash
docker build -t smart-auto-deploy:latest .
```

- `build` = creates an image
- `-t smart-auto-deploy:latest` = name:tag
- `.` = Dockerfile context (current folder)

### Run a container

```bash
docker run --rm -p 5000:5000 smart-auto-deploy:latest
```

- `-p 5000:5000` maps your PC port to container port

### Common cleanup

```bash
docker ps
docker images
docker rmi <image_id>
```

---

## 6) AWS EC2 setup (Linux beginner steps)

### 6.1 Create EC2 instance
1. Go to AWS Console → **EC2**
2. Launch Instance
3. Choose a Linux AMI (Ubuntu 22.04 or Amazon Linux)
4. Instance type: `t2.micro` (or similar free-tier)
5. Create/choose Security Group:
   - **Inbound SSH** (port 22) from your IP
   - **Inbound HTTP** (port 5000 OR 80 if you configure a reverse proxy)

> In this project the container listens on **5000**.

### 6.2 Connect to EC2 using SSH

From your PC, you need your `.pem` key file.

In terminal:

```bash
ssh -i /path/to/your-key.pem ubuntu@YOUR_EC2_PUBLIC_IP
```

- Replace `/path/to/your-key.pem` with your file
- Replace `ubuntu@...` with the right user depending on your AMI:
  - Ubuntu images often use `ubuntu`
  - Amazon Linux often uses `ec2-user`

---

## 7) Install Docker on EC2

Run inside EC2:

### Ubuntu example

```bash
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
newgrp docker
```

### Check Docker

```bash
docker --version
docker ps
```

---

## 8) Run the container on EC2 (manual test)

If you want to test before CI/CD:

1. Build image locally (on your PC):

```bash
docker build -t smart-auto-deploy:latest .
```

2. Copy image to EC2 (simple approach)

For beginners, easiest is to let GitHub Actions handle it.
But you can test by:
- creating a Docker image on EC2 using the repo (clone)
- then running it.

CI/CD below will do this automatically.

---

## 9) GitHub Actions CI/CD (how it works)

The workflow does:
1. Triggers on every push to `main`
2. SSH to EC2
3. On EC2:
   - install Docker (optional if already installed)
   - pull your latest repo code (`git pull`)
   - build Docker image
   - stop old container
   - run new container

---

## 10) GitHub Secrets you must configure

In GitHub repository:
**Settings → Secrets and variables → Actions → New repository secret**

Add these secrets (names must match the workflow file):
- `EC2_HOST` = public IP or DNS
- `EC2_USER` = `ubuntu` or `ec2-user`
- `EC2_SSH_KEY` = contents of your `.pem` file (paste as text)
- `AWS_DEPLOY_DIR` = folder on EC2 for your project (e.g. `/home/ubuntu/smart-auto-deploy`)

Also ensure you have AWS inbound SSH allowed from your IP.

Also add this extra secret because the workflow clones your code on first run:
- `GITHUB_REPO_URL` = your repository clone URL (for example: `https://github.com/<user>/<repo>.git`)


---

## 11) Deploy after every git push

When you push your code:

1. GitHub Actions automatically starts
2. It SSHs into EC2
3. Rebuilds the Docker image
4. Restarts the container with the new code

You can watch Actions status:
- GitHub → your repo → **Actions**

---

## 12) Troubleshooting (common beginner errors)

### Error: `Permission denied (publickey)`
- Wrong `EC2_USER`
- Wrong `EC2_SSH_KEY`
- Security group does not allow SSH from your IP

### Error: Docker not found
- Docker install failed
- Ensure you ran Docker install steps on EC2

### Error: Container won’t start / port not open
- Check EC2 Security Group inbound rules
- Your container listens on port 5000

### Error: GitHub Actions cannot connect via SSH
- `EC2_HOST` incorrect
- Security group SSH inbound missing
- Secret formatting problem (key has extra quotes/newlines)

---

## Next step

After creating the files, you only need:
1) Create a GitHub repository
2) Push this folder to GitHub (commit + push)
3) Add GitHub Actions secrets
4) Every push to `main` will auto-deploy to EC2.


