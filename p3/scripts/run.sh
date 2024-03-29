#!/bin/bash
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
BLUE="\e[34m"

namespace="argocd"
sleep 10
while true; do

    running_pods=$(kubectl get pod -n $namespace | grep -cE "Running|Completed")
    total_pods=$(kubectl get pod -n $namespace | grep -c "argocd-")

    if [ "$running_pods" -eq "$total_pods" ]; then
        echo -e "${YELLOW} Get secret argocd-initial-admin-secret ...${ENDCOLOR}"
        password=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
        username="admin"
        echo "Username: $username"
        echo "Password: $password"
        echo -e "${YELLOW} ====================================================${ENDCOLOR}"


        echo -e "${YELLOW} forwarding  ...${ENDCOLOR}"
         kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8080:80 
         # kubectl port-forward --address 0.0.0.0  pod/app-one-6c64649c58-9ph46 -n dev 8080:80
        echo -e "${YELLOW} ====================================================${ENDCOLOR}"
      break
    else
      echo "${BLUE}Waiting for pods to be in Running state..."
    fi
  sleep 5
done