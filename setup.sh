#!/bin/bash
echo "Installing required tools..."
sudo apt update 
sudo apt install -y stress-ng smartmontools lm-sensors 
sudo sensors-detect --auto
echo "Setup is completed."
