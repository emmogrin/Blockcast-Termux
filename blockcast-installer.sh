#!/bin/bash

echo "╔═══════════════════════════════════════╗"
echo "║   BLOCKCAST BEACON AUTO-INSTALLER    ║"
echo "║         by SAINT KHEN — @admirkhen   ║"
echo "╚═══════════════════════════════════════╝"
echo ""

echo ">>> BLOCKCAST BEACON SETUP STARTING..."

# Check if Docker is installed
if ! command -v docker &> /dev/null
then
  echo "Docker not found. Please install Docker first:"
  echo "https://docs.docker.com/get-docker/"
  exit 1
fi

# Check if Docker daemon is running
if ! docker info > /dev/null 2>&1; then
  echo "Docker daemon is not running. Attempting to start Docker..."
  # Try to start Docker service (for systemd systems)
  if command -v systemctl &> /dev/null; then
    sudo systemctl start docker
    sleep 3
    if ! docker info > /dev/null 2>&1; then
      echo "Failed to start Docker daemon. Please start it manually and rerun the script."
      exit 1
    fi
  else
    echo "Cannot auto-start Docker daemon. Please start it manually and rerun."
    exit 1
  fi
fi

# Clone the repo or update if it exists
REPO_DIR="beacon-docker-compose"
REPO_URL="https://github.com/Blockcast/beacon-docker-compose.git"

if [ ! -d "$REPO_DIR" ]; then
  echo ">>> Cloning Blockcast Docker Compose repo..."
  git clone $REPO_URL || {
    echo "Failed to clone repository. Please check your network or try manually."
    exit 1
  }
else
  echo ">>> Repo already exists, pulling latest changes..."
  cd "$REPO_DIR" || exit 1
  git pull origin main || {
    echo "Failed to pull latest changes. Continuing with existing files."
  }
  cd ..
fi

cd "$REPO_DIR" || {
  echo "Failed to enter repo directory."
  exit 1
}

# Start the containers
echo ">>> Starting Blockcast BEACON Node containers..."
docker compose up -d || {
  echo "Failed to start containers."
  exit 1
}

echo ">>> Checking container status..."
docker compose ps

echo ">>> Waiting for containers to initialize..."
sleep 5

# Initialize and fetch Hardware ID + Challenge Key
echo ">>> Initializing node to get Hardware ID & Challenge Key..."
docker compose exec blockcastd blockcastd init

echo ""
echo ">>> SETUP COMPLETE!"
echo "1. Copy your Hardware ID, Challenge Key, and Registration URL from above."
echo "2. Visit: https://app.blockcast.network/"
echo "3. Paste your Registration URL or manually register your node."
echo "4. Leave your node running 24/7 to earn rewards!"
echo ""
echo ">>> TIP: Backup your private key:"
echo "~/.blockcast/certs/gw_challenge.key"
echo ""
echo ">>> SAINT KHEN — @admirkhen signing off."
exit 0
