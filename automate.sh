#!/bin/bash

cd ~

mkdir -p game

cd game

wget -O game.zip https://file.io/NlhcuXwEeqO9

unzip game.zip

mkdir -p ~/.config/autostart/automation
mv jackpot.desktop1 ~/.config/autostart/automation

if [ -f requirements.txt ]; then
    sudo pip3 install -r requirements.txt
else
    sudo pip3 install --upgrade pip
    sudo pip3 install pygame
    sudo pip3 install gif-pygame
fi

echo "Setup complete."
