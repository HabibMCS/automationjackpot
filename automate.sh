#!/bin/bash
# Install Wine
sudo dpkg --add-architecture i386
sudo mkdir -pm755 /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/$(lsb_release -cs)/winehq-$(lsb_release -cs).sources
sudo apt update
sudo apt install --install-recommends winehq-stable
wine --version

# Create directories
cd ~
mkdir -p jackpot

# Download and unzip the game
cd jackpot
wget -O game.zip https://file.io/m5l8QNOe99Ll
unzip game.zip

# Move run_test.sh to the correct location and make it executable
chmod +x ~/jackpot/run_test.sh
sudo apt install python3-pip
# Install Python requirements
if [ -f requirements.txt ]; then
    sudo pip3 install -r requirements.txt
else
    sudo pip3 install --upgrade pip
    sudo pip3 install pygame
    sudo pip3 install gif-pygame
    sudo pip3 install tk
fi

# Create the systemd service file
sudo bash -c 'cat << EOF > /etc/systemd/system/pygame_gui.service
[Unit]
Description=Run Pygame GUI at startup
After=multi-user.target

[Service]
Type=simple
ExecStart=/home/jorge/jackpot/run_test.sh
Restart=on-failure
User=jorge
Environment=DISPLAY=:0
Environment=XAUTHORITY=/run/user/1000/gdm/Xauthority

[Install]
WantedBy=multi-user.target
EOF'

# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable pygame_gui.service
sudo systemctl start pygame_gui.service

echo "Setup complete."
