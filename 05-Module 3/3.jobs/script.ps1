$NS = "jobs-upskilling"
kubectl create namespace $NS

kubectl apply -n $NS -f countdown-job.yaml

#check
kubectl get job,pod -n $NS

kubectl delete -n $NS -f countdown-job.yaml


#####################
kubectl apply -n $NS -f sample-cron-job.yaml

#check
kubectl get cronjob,pod -n $NS

kubectl delete -n $NS -f sample-cron-job.yaml

kubectl delete namespace $NS