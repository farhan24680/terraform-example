#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Updating system packages..."
sudo apt-get update -y

echo "Installing NGINX..."
sudo apt-get install nginx -y

echo "Enabling and starting NGINX..."
sudo systemctl enable nginx
sudo systemctl start nginx

echo "Checking NGINX status..."
sudo systemctl status nginx | grep Active

echo "NGINX has been installed and started successfully!"
