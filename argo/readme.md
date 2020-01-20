(base) ➜  share kubectl create ns argo
namespace/argo created
(base) ➜  share kubectl apply -n argo -f https://raw.githubusercontent.com/argoproj/argo/v2.3.0/manifests/install.yaml
customresourcedefinition.apiextensions.k8s.io/workflows.argoproj.io created
serviceaccount/argo-ui created
serviceaccount/argo created
clusterrole.rbac.authorization.k8s.io/argo-aggregate-to-admin created
clusterrole.rbac.authorization.k8s.io/argo-aggregate-to-edit created
clusterrole.rbac.authorization.k8s.io/argo-aggregate-to-view created
clusterrole.rbac.authorization.k8s.io/argo-cluster-role created
clusterrole.rbac.authorization.k8s.io/argo-ui-cluster-role created
clusterrolebinding.rbac.authorization.k8s.io/argo-binding created
clusterrolebinding.rbac.authorization.k8s.io/argo-ui-binding created
configmap/workflow-controller-configmap created
service/argo-ui created
deployment.apps/argo-ui created
deployment.apps/workflow-controller created
(base) ➜  share kubectl get po  -n argo
NAME                                   READY   STATUS    RESTARTS   AGE
argo-ui-76c6cf75b4-wrrtt               1/1     Running   0          9s
workflow-controller-69f6ff7cbc-rtwmh   1/1     Running   0          9s
(base) ➜  share kubectl get svc -n argo
NAME      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
argo-ui   ClusterIP   10.110.20.178   <none>        80/TCP    51s
(base) ➜  share kubectl edit svc argo-ui -n argo
service/argo-ui edited
spec:
......
  sessionAffinity: None
  type: NodePort
......
(base) ➜  share kubectl get svc -n argo
NAME      TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
argo-ui   NodePort   10.110.20.178   <none>        80:30856/TCP   2m26s
(base) ➜  share kubectl get crd | grep argo
workflows.argoproj.io                     2020-01-10T03:25:30Z
(base) ➜  share kubectl api-version | grep argo
Error: unknown command "api-version" for "kubectl"

Did you mean this?
        api-versions

Run 'kubectl --help' for usage.
unknown command "api-version" for "kubectl"

Did you mean this?
        api-versions

(base) ➜  share kubectl api-versions | grep argo
argoproj.io/v1alpha1
(base) ➜  share kubectl get svc
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   90d
(base) ➜  share kubectl get svc -n argo
NAME      TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
argo-ui   NodePort   10.110.20.178   <none>        80:30856/TCP   4m31s
(base) ➜  share ping 10.110.20.178
PING 10.110.20.178 (10.110.20.178) 56(84) bytes of data.
64 bytes from 10.110.20.178: icmp_seq=1 ttl=128 time=3.28 ms
64 bytes from 10.110.20.178: icmp_seq=2 ttl=128 time=1.59 ms
^C
--- 10.110.20.178 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 1.595/2.440/3.286/0.846 ms
(base) ➜  share telnet 10.110.20.178 30856
Trying 10.110.20.178...
^C
(base) ➜  share kubectl get -n argo svc
NAME      TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
argo-ui   NodePort   10.110.20.178   <none>        80:30856/TCP   6m7s
(base) ➜  share netstat -anlpto | grep 30856
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
tcp        0      1 192.168.237.128:56700   10.110.20.178:30856     SYN_SENT    38885/chrome --type  on (0.43/0/0)
tcp        0      1 192.168.237.128:56708   10.110.20.178:30856     SYN_SENT    38885/chrome --type  on (0.68/0/0)
tcp        0      1 192.168.237.128:56702   10.110.20.178:30856     SYN_SENT    38885/chrome --type  on (0.43/0/0)
tcp6       3      0 :::30856                :::*                    LISTEN      -                    off (0.00/0/0)
tcp6     614      0 ::1:30856               ::1:46126               CLOSE_WAIT  -                    off (0.00/0/0)
tcp6       1      0 ::1:30856               ::1:46282               CLOSE_WAIT  -                    off (0.00/0/0)
tcp6     643      0 ::1:30856               ::1:46128               CLOSE_WAIT  -                    off (0.00/0/0)

