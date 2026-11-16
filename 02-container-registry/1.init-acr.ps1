$ACR_NAME="upskillingk8sacr"
az acr import --name $ACR_NAME --source docker.io/library/nginx:latest --image nginx:latest

az acr import --name $ACR_NAME --source ghcr.io/marcelloraffaele/hello:main --image hello:main