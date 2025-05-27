# ╔═══════════════════════════════════════╗
# ║   BLOCKCAST BEACON AUTO-INSTALLER    ║
# ║      by SAINT KHEN — @admirkhen      ║
# ╚═══════════════════════════════════════╝

echo ">>> BLOCKCAST BEACON SETUP STARTING..."

# Check if Docker is installed
if ! command -v docker &> /dev/null
then
    echo "Docker not found. Please install Docker first: https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Clone the repo
echo ">>> Cloning Blockcast Docker Compose repo..."
git clone https://github.com/Blockcast/beacon-docker-compose.git || {
    echo "Repo already exists or cloning failed. Moving on..."
}
cd beacon-docker-compose || {
    echo "Failed to enter directory. Make sure it exists."
    exit 1
}

# Start the containers
echo ">>> Starting Blockcast BEACON Node..."
docker compose up -d

echo ">>> Checking container status..."
docker compose ps

# Wait a few seconds to ensure services are up
sleep 5

# Initialize and fetch Hardware ID + Challenge Key
echo ">>> Initializing node to get Hardware ID & Challenge Key..."
docker compose exec blockcastd blockcastd init

echo ""
echo ">>> DONE! Now follow the next steps:"
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
