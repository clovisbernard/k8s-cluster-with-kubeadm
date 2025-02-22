# in the master node
sudo kubeadm token create  --print-join-command

# in the worker node
sudo swapoff -a
# Load the br_netfilter module:
sudo modprobe br_netfilter
lsmod | grep br_netfilter
echo 1 | sudo tee /proc/sys/net/bridge/bridge-nf-call-iptables
sudo sh -c 'echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf'
sudo sysctl -p

# execute the command provided with kubeadm token create
sudo kubeadm join ...........


# this command starts kubelet and configure it to file /var/lib/kubelet/ocnfig.yaml

# check connectivity between pods.
kubectl exec -n kube-system cilium-6hj4c -- cilium status

Cluster health:          1/3 reachable   (2025-01-14T23:24:41Z)
  Name                   IP              Node          Endpoints
  kubernetes/worker1     172.31.37.148   unreachable   reachable
  kubernetes/worker2     172.31.35.244   unreachable   reachable
Modules Health:          Stopped(0) Degraded(0) OK(43)

# if you have this output, check the port cilium in documentation and update the security group
Cluster health:          3/3 reachable   (2025-01-15T00:24:41Z)
Modules Health:          Stopped(0) Degraded(0) OK(43)

# check connectivity with this command
 cilium connectivity test
# test shceduling a pod and check if it is running in the differents pod
kubectl run test --image=nginx --replicas=10