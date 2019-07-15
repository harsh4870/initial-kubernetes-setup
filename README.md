# initial-kubernetes-setup
Initial kubernetes setup shell script to install nginx ingress, tiller &amp; cert-manager

This shell script is for the initial setup of kubernetes cluster which include the nginx ingress controller, tiller server and cert-manager.

Add the path of kubernetes config file in environment variable `kubeconfig`. If kubernetes config file is already set in `$HOME/.kube/config` you can run script without setting up environment variable.

