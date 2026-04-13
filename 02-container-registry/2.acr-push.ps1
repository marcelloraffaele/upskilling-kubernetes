$ACR_NAME="acrupskilling"

az acr login --name $ACR_NAME

docker tag app-nginx:1.0 "$ACR_NAME.azurecr.io/app-nginx:1.0"
docker push "$ACR_NAME.azurecr.io/app-nginx:1.0"