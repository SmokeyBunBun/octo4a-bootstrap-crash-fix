#!/bin/bash

set -e

# Update package lists
sudo apt update

# Install required dependencies
sudo apt install -y python3-pip python3-yaml python3-regex python3-zeroconf python3-netifaces python3-cffi python3-psutil unzip python3-pil ttyd ffmpeg

# Create necessary directories
mkdir -p /opt/octoprint/extensions/ttyd

# Create manifest file
cat << EOF > /opt/octoprint/extensions/ttyd/manifest.json
{
        "title": "Remote web terminal (ttyd)",
        "description": "Uses port 5002; User smokey / ssh password (found in ~/.octoCredentials)"
}
EOF

# Store the credential for your user
echo "smokey" > /home/smokey/.octoCredentials

# Create start script
cat << EOF > /opt/octoprint/extensions/ttyd/start.sh
#!/bin/bash
ttyd -p 5002 --credential smokey:\$(cat /home/smokey/.octoCredentials) bash
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

# Install pip packages
python3 -m pip install -U packaging --ignore-installed
python3 -m pip install https://github.com/feelfreelinux/octo4a-argon2-mock/archive/main.zip

# Create the argon fix file in your home directory
touch /home/smokey/.argon-fix

echo "TTYD extension files created in /opt/octoprint/extensions/ttyd/"
echo "Start script: /opt/octoprint/extensions/ttyd/start.sh"
echo "Kill script: /opt/octoprint/extensions/ttyd/kill.sh"
echo "Credentials stored in /home/smokey/.octoCredentials (user: smokey)"
echo "You may need to configure OctoPrint to recognize this extension."
