kubeadm reset 
kubeadm init
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl get node 
kubectl describe node

# 安装网络插件
kubectl apply -f /mnt/hgfs/share/weave*
kubectl get nodes

# 去掉master taint
kubectl taint nodes --all node-role.kubernetes.io/master-

# 安装持久化插件
kubectl create namespace rook-ceph

helm install --namespace rook-ceph-system rook-beta/rook-ceph --name rook-ceph 

# helm ls 
helm init
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'


