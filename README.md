SAINT KHEN’s Termux + Debian VM Guide for Blockcast BEACON

Step 1: Prep Termux Environment
```bash
pkg update && pkg upgrade -y
```
```bash
pkg install wget curl proot unzip tar -y
```
```bash
pkg install x11-repo -y
```
```bash
pkg install qemu-utils qemu-system-x86_64 -y
```


---

Step 2: Download Debian VM Image
```bash
mkdir -p ~/qemu-debian && cd ~/qemu-debian
wget https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-nocloud-amd64.qcow2 -O debian-11.qcow2
```

---

Step 3: Launch Debian VM
```
qemu-system-x86_64 \
  -m 2048 \
  -smp 2 \
  -drive file=debian-11.qcow2,format=qcow2 \
  -net nic -net user,hostfwd=tcp::2222-:22 \
  -nographic

```
Login: root

---

Step 4: Inside Debian — Set Up Docker + Blockcast
```bash
apt update && apt upgrade -y
```
```bash
apt install curl wget git build-essential -y
```
```bash
curl -fsSL https://get.docker.com | sh
```
```bash
dockerd &
```


---

Step 5: Clone & Run Blockcast Installer

```bash
git clone https://github.com/emmogrin/blockcast-beacon-auto.git
cd blockcast-beacon-auto
chmod +x blockcast-beacon-install.sh
./blockcast-beacon-install.sh
```

---

After Running the Script

1. Copy the Hardware ID, Challenge Key, and Registration URL from the terminal output.
2. Visit https:
 ```bash
 https://app.blockcast.network?referral-code=0srony
 ```

3. Register your node using the URL or manually.
 
 Keep your node online for:
6 hours to pass connectivity checks
24 hours to start earning rewards

---

Important

Docker is required. Install it first: https://www.docker.com/products/docker-desktop

Backup your private key from:
~/.blockcast/certs/gw_challenge.key
---
To restart the node after a system reboot:
```bash
cd qemu-debian 
```
```bash
qemu-system-x86_64 \
  -m 2048 \
  -smp 2 \
  -drive file=debian-11.qcow2,format=qcow2 \
  -net nic -net user,hostfwd=tcp::2222-:22 \
  -nographic
```

 ```bash
 cd blockcast-beacon-auto && cd beacon-docker-compose
```
```bash
 docker compose up -d
 ```
This will resume your Blockcast node without resetting your keys or registration.

---
To check logs :
```bash
docker compose logs -f blockcastd
```
most variables would have successful attached to them.
and it would display online in the main site.

Credits

SAINT KHEN
Twitter: @admirkhen
GitHub: emmogrin


