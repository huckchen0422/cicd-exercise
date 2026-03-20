TYPE=${TYPE:KUBEADM}

if [ "${TYPE}" = "KIND" ]; then
    export NODE=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' kind-worker)
elif [ "${TYPE}" = "GITHUB-KIND" ]; then
    export NODE=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
elif [ "${TYPE}" = "minikube" ]; then
    export NODE=$(kubectl get nodes minikube -o jsonpath='{.status.addresses[0].address}')
elif [ "${TYPE}" = "KUBEADM" ]; then
    # 抓取主節點的 IP（假設主節點為 master）
    export NODE=$(kubectl get nodes -o wide -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
else
    echo "Unknown environment type: ${TYPE}"
    exit 1
fi
