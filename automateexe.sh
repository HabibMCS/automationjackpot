#!/bin/bash

# Get the original user
ORIGINAL_USER=${SUDO_USER:-$(whoami)}

# Create directories
cd /home
mkdir -p /home/jackpot
sudo chown -R $ORIGINAL_USER:$ORIGINAL_USER /home/
sudo chown -R jorge:jorge /home/
sudo chown -R tcm:tcm /home/
sudo chown -R $ORIGINAL_USER:$ORIGINAL_USER /home/jackpot

# Download and unzip the game
cd /home/$ORIGINAL_USER/jackpot
wget -O gameexe.zip "https://nustedupk0-my.sharepoint.com/:u:/g/personal/hsolangi_bee-57mcs_student_nust_edu_pk/EbYMiTKOiL9HlAejzyOaYPsBQdGnW9Bk_R0JELwHBZA5vg?e=nvgtV2&download=1"
unzip gameexe.zip

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
