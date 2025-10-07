# run demo

```bash
$NS="demo2-cron"
kubectl create ns $NS


kubectl apply -f workload-dep.yaml -n $NS
kubectl apply -f keda-cron.yaml -n $NS

#Observe pod replicas increase every 2nd minute and decrease every 4th minutes
#Discuss how this can be used to scale a workload in preparation for a known event

kubectl get hpa -n $NS -w

kubectl get scaledobjects -n $NS

kubectl logs -f -n kube-system -l app=keda-operator

# cleanup
kubectl delete ns $NS

#Explanation
#
#This is a KEDA cron scaler entry (timezone Etc/UTC).
#KEDA uses the start and end cron expressions to define a time window during which it sets the target to desiredReplicas (here "52").
#What the two cron lines mean
#
#start: 1/2 * * * *
#"Every 2 minutes starting at minute 1" → matches minutes {1, 3, 5, 7, ... , 59} (UTC).
#end: 1/4 * * * *
#"Every 4 minutes starting at minute 1" → matches minutes {1, 5, 9, 13, ... , 57} (UTC).
#Behavior summary
#
#KEDA will attempt to scale the target to 52 replicas for each interval between a matching start time and the next matching end time. #Because start fires every 2 minutes and end every 4 minutes, this produces a sequence of short, repeating windows (for example, a #window from minute 3 until minute 5, from 7 until 9, etc.). Note that both schedules match at minute 1, creating an ambiguous or #zero-length window at those times — that is a gotcha.
```