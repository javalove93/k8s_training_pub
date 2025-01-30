PODS=$(kubectl get pod | grep -v NAME | awk '{print $1}')
for POD in $PODS; do
  kubectl exec -t $POD -- curl -s localhost:8080/memhog && echo "" &
done

wait
# kubectl get pod | grep -v NAME | awk '{print "kubectl exec -t " $1 " -- curl -s localhost:8080/memhog ; echo"}' | sh -x &
