#!/bin/bash
ACR_NAME=""
ACR_USERNAME=""
ACR_PASSWORD=""
# This script initializes an Azure Container Registry (ACR) 
# and pulls a Docker image from GitHub Container Registry (GHCR).
sudo docker pull ghcr.io/marcelloraffaele/hello:main
# tag the image to local registry
sudo docker tag ghcr.io/marcelloraffaele/hello:main hello:main

# Login to Azure Container Registry
sudo docker login -u $ACR_USERNAME -p $ACR_PASSWORD $ACR_NAME.azurecr.io

# Push the image to Azure Container Registry
sudo docker push $ACR_NAME.azurecr.io/hello:main