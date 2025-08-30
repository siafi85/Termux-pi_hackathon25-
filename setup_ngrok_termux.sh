#!/bin/bash

echo "[1/4] Updating Termux and installing tools..."
pkg update -y
pkg upgrade -y
pkg install wget unzip curl -y

PROJECT_DIR="$HOME/pi_hackathon25"
echo "[2/4] Moving to project directory: $PROJECT_DIR"
cd $PROJECT_DIR || { echo "Project directory not found!"; exit 1; }

echo "[3/4] Downloading ngrok..."
wget -q https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip
unzip -o ngrok-stable-linux-arm.zip
chmod +x ngrok

read -p "Enter your ngrok authtoken: " NGROK_TOKEN
./ngrok authtoken $NGROK_TOKEN

echo "[4/4] Starting ngrok on port 3000..."
./ngrok http 3000
