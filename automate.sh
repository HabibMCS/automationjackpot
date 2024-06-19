#!/bin/bash
# install wine
sudo dpkg --add-architecture i386
sudo mkdir -pm755 /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/$(lsb_release -cs)/winehq-$(lsb_release -cs).sources
sudo apt update
sudo apt install --install-recommends winehq-stable
wine --version


cd ~

mkdir -p jackpot

cd jackpot

wget -O game.zip https://file.io/NlhcuXwEeqO9

unzip game.zip

mkdir -p ~/.config/autostart/automation
mv jackpot.desktop ~/.config/autostart/automation/
chmod +x ~/.config/autostart/automation/jackpot.desktop
chmod +x ~/jackpot/run_test.sh

if [ -f requirements.txt ]; then
    sudo pip3 install -r requirements.txt
else
    sudo pip3 install --upgrade pip
    sudo pip3 install pygame
    sudo pip3 install gif-pygame
fi

echo "Setup complete."
