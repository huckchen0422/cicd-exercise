TYPE=${TYPE:KUBEADM}

if [ "${TYPE}" = "KIND" ]; then
    export NODE=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' kind-worker)
elif [ "${TYPE}" = "minikube" ]; then
    export NODE=$(kubectl get nodes minikube -o jsonpath='{.status.addresses[0].address}')
elif [ "${TYPE}" = "KUBEADM" ]; then
    # 在 kubeadm 環境中，抓取主節點的 IP（假設主節點為 master）
    # export NODE=$(kubectl get nodes -o jsonpath='{.items[?(@.metadata.labels.kubernetes\.io/role=="master")].status.addresses[0].address}')
    export NODE=$(kubectl get nodes -o wide -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
else
    # 如果沒有指定 TYPE，或者指定的是其他環境（可以擴展為其他處理邏輯）
    echo "Unknown environment type: ${TYPE}"
    exit 1
fi
