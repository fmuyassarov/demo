#!/bin/bash

ns=${NS:-default}
for pod in $(kubectl -n $ns get pods | tr -s '\t' ' ' |
                 cut -d ' ' -f1 | grep -v ^NAME | tr -d '"'); do
    for ctr in $(kubectl get -n $ns pod $pod -o json |
                     jq '.spec.containers[].name' | tr -d '"'); do
        echo "* resources for $pod:$ctr"
        kubectl exec -n $ns -c $ctr $pod -- cat /proc/self/status |
            grep _allowed_list | sed 's/^/    /g'
    done
done
