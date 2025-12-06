echo "Cleaning up Kubernetes resources..."
kubectl delete job --all
kubectl delete deployment --all
kubectl delete statefulset --all
kubectl delete service --all
kubectl delete pvc --all
kubectl delete configmap --all
kubectl delete secret --all

echo "Cleanup complete!"
