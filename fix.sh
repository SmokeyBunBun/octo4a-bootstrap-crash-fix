#!/bin/bash

set -e

# Update package lists
sudo apt update

# Install required dependencies via apt
sudo apt install -y python3-pip python3-yaml python3-regex python3-zeroconf python3-netifaces python3-cffi python3-psutil unzip python3-pil ttyd ffmpeg python3-packaging python3-venv python3-full python3-argon2

# Create necessary directories
sudo mkdir -p /opt/octoprint/extensions/ttyd

# Create manifest file
cat << EOF > /opt/octoprint/extensions/ttyd/manifest.json
{
    "title": "Remote web terminal (ttyd)",
    "description": "Uses port 8022; User $USER / ssh password (found in ~/.octoCredentials)"
}
EOF

# Store the credential for your user
echo "$USER" > /home/$USER/.octoCredentials

# Create start script
cat << EOF > /opt/octoprint/extensions/ttyd/start.sh
#!/bin/bash
ttyd -p 8022 --credential $USER:\$(cat /home/$USER/.octoCredentials) bash
EOF

# Create kill script
cat << EOF > /opt/octoprint/extensions/ttyd/kill.sh
#!/bin/bash
pkill ttyd
EOF

# Make the scripts executable
chmod +x /opt/octoprint/extensions/ttyd/start.sh
chmod +x /opt/octoprint/extensions/ttyd/kill.sh

# Adjust permissions
chmod 755 /opt/octoprint/extensions/ttyd/start.sh
chmod 755 /opt/octoprint/extensions/ttyd/kill.sh

# Create the argon fix file in your home directory
touch /home/$USER/.argon-fix

echo "TTYD extension files created in /opt/octoprint/extensions/ttyd/"
echo "Start script: /opt/octoprint/extensions/ttyd/start.sh"
echo "Kill script: /opt/octoprint/extensions/ttyd/kill.sh"
echo "Credentials stored in /home/$USER/.octoCredentials (user: $USER)"
echo "You may need to configure OctoPrint to recognize this extension."
