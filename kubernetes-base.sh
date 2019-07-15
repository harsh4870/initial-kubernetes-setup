#!/usr/bin/env bash
kubeconfig=""
if [ -z $kubeconfig ]
then
   echo "install helm"
   curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
   kubectl --namespace kube-system create sa tiller
   kubectl create clusterrolebinding tiller \
    --clusterrole cluster-admin \
    --serviceaccount=kube-system:tiller
   echo "initialize helm"
   helm init --service-account tiller
   helm repo update
   echo "verify helm"
   kubectl get deploy,svc tiller-deploy -n kube-system
   #Get nginx ingress controller 
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.24.1/deploy/mandatory.yaml
   #Get Load balancer for ingress controller
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.24.1/deploy/provider/cloud-generic.yaml
   #Set the CRD for cert-manager 
   kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.8/deploy/manifests/00-crds.yaml
   #Adding validation false
   #kubectl label namespace kube-system certmanager.k8s.io/disable-validation="true"
   #Get the cert-manager installed
   kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.6/deploy/manifests/cert-manager.yaml --validate=false
   #Note : if running kubectl v1.12 or below then use the --validate=false tag
else
   echo "install helm"
   curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
   kubectl --kubeconfig=$kubeconfig --namespace kube-system create sa tiller
   kubectl --kubeconfig=$kubeconfig create clusterrolebinding tiller \
    --clusterrole cluster-admin \
    --serviceaccount=kube-system:tiller
   echo "initialize helm"
   helm --kubeconfig=$kubeconfig init --service-account tiller
   helm --kubeconfig=$kubeconfig repo update
   echo "verify helm"
   kubectl --kubeconfig=$kubeconfig get deploy,svc tiller-deploy -n kube-system
   #Get nginx ingress controller 
   kubectl --kubeconfig=$kubeconfig apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.24.1/deploy/mandatory.yaml
   #Get Load balancer for ingress controller
   kubectl --kubeconfig=$kubeconfig apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.24.1/deploy/provider/cloud-generic.yaml
   #Set the CRD 
   kubectl --kubeconfig=$kubeconfig apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.8/deploy/manifests/00-crds.yaml
   #Get the cert-manager installed
   kubectl --kubeconfig=$kubeconfig apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.6/deploy/manifests/cert-manager.yaml --validate=false
   #Note : if running kubectl v1.12 or below then use the --validate=false tag
fi
 
