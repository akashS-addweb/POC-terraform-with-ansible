#!/bin/bash

# ==============================
# Automate Terraform, Docker & Ansible
# ==============================

set -e

# Colors for better readability
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

# Step 1: Docker Build and Push
echo -e "${YELLOW}➡️  Building Docker Image...${NC}"
cd node-app

docker build -t enter-your-docker-username/enter-your-image-name:latest .
echo -e "${GREEN}✅ Docker Image Built.${NC}"

echo -e "${YELLOW}➡️  Logging into Docker Hub...${NC}"
echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USERNAME" --password-stdin

echo -e "${YELLOW}➡️  Pushing Docker Image to Docker Hub...${NC}"
docker push enter-your-docker-username/enter-your-image-name:latest
echo -e "${GREEN}✅ Docker Image Pushed to Docker Hub.${NC}"

# Step 2: Create SSH Key for EC2 Instance and Ansible
echo -e "${YELLOW}➡️  Generating SSH Key...${NC}"
ssh-keygen -t rsa -b 4096 -f ../ssh/<enter_your_key_name> -N ""
echo -e "${GREEN}✅ Successfully Created SSH Key.${NC}"

# Step 3: Navigate to Terraform directory
echo -e "${YELLOW}➡️  Navigating to Terraform directory...${NC}"
cd ../terraform

# Step 4: Terraform Initialization
echo -e "${YELLOW}➡️  Initializing Terraform...${NC}"
terraform init

# Step 5: Terraform Apply to provision EC2
echo -e "${GREEN}🚀 Deploying infrastructure with Terraform...${NC}"
terraform apply -auto-approve

