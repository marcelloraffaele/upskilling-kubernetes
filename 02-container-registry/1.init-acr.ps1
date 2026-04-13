$ACR_NAME="acrupskilling"
az acr import --name $ACR_NAME --source docker.io/library/nginx:latest --image nginx:v1

az acr import --name $ACR_NAME --source ghcr.io/marcelloraffaele/hello:main --image hello:main