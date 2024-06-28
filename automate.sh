#!/bin/bash
# Install Wine
sudo dpkg --add-architecture i386
sudo mkdir -pm755 /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/$(lsb_release -cs)/winehq-$(lsb_release -cs).sources
sudo apt update
sudo apt install --install-recommends winehq-stable
wine --version

# Get the original user
ORIGINAL_USER=${SUDO_USER:-$(whoami)}

# Create directories
cd ..
mkdir -p /home/$ORIGINAL_USER/jackpot
sudo chown -R $ORIGINAL_USER:$ORIGINAL_USER /home/$ORIGINAL_USER
sudo chown -R $ORIGINAL_USER:$ORIGINAL_USER /home/$ORIGINAL_USER/jackpot

# Download and unzip the game
cd /home/$ORIGINAL_USER/jackpot
wget -O game.zip "https://nustedupk0-my.sharepoint.com/:u:/g/personal/hsolangi_bee-57mcs_student_nust_edu_pk/EZkdpRMcwK5CsdGqa3ao2swBwmNSfhSpjwPi_ToC_mrkDg?e=ApaTlI&download=1"
unzip game.zip

# Move run_test.sh to the correct location and make it executable
sed -i 's/\r$//' /home/$ORIGINAL_USER/jackpot/run_test.sh
chmod +x ./run_test.sh

# Install Python and Tkinter
sudo apt install -y python3-pip python3-tk

# Install Python requirements
if [ -f requirements.txt ]; then
    sudo pip3 install -r requirements.txt
else
    sudo pip3 install --upgrade pip
    sudo pip3 install pygame gif-pygame
fi

# Create the systemd service file
sudo bash -c "cat << EOF > /etc/systemd/system/pygame_gui.service
[Unit]
Description=Run Pygame GUI at startup
After=multi-user.target

[Service]
Type=simple
ExecStart=/home/$ORIGINAL_USER/jackpot/run_test.sh
Restart=on-failure
User=$ORIGINAL_USER
Environment=DISPLAY=:0
Environment=XAUTHORITY=/run/user/1000/gdm/Xauthority

[Install]
WantedBy=multi-user.target
EOF"

# Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable pygame_gui.service
sudo systemctl start pygame_gui.service

echo "Setup complete."
