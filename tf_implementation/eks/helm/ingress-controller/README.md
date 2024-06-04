Installation of ingress controller for services

- Install 
  helm install -n ingress-controller ingress-nginx-services ingress-nginx/ingress-nginx --values ./vars/development/values_services.yaml

- Check before upgrading 
  helm diff upgrade -n ingress-controller ingress-nginx-services ingress-nginx/ingress-nginx --values ./vars/development/values_services.yaml

- Upgrade 
  helm upgrade -n ingress-controller ingress-nginx-services ingress-nginx/ingress-nginx --values ./vars/development/values_services.yaml

- Remove 
  helm uninstall -n ingress-controller ingress-nginx-services


Installation of ingress controller for tools

- Install 
  helm install -n ingress-controller ingress-nginx-tools ingress-nginx/ingress-nginx --values ./vars/development/values_tools.yaml

- Check before upgrading 
  helm diff upgrade -n ingress-controller ingress-nginx-tools ingress-nginx/ingress-nginx --values ./vars/development/values_tools.yaml

- Upgrade 
  helm upgrade -n ingress-controller ingress-nginx-tools ingress-nginx/ingress-nginx --values ./vars/development/values_tools.yaml

- Remove 
  helm uninstall -n ingress-controller ingress-nginx-tools