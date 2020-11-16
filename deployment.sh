# Define Variables
RG=resourcegroupak
LOCATION=westeurope 
AKS_CLUSTER_NAME=k8s-akhamessi

### create RG
$ az group create --name $RG --location $LOCATION

### first we create the SP that we will use and assign permissions on the VNET
$ az ad sp create-for-rbac -n "akhamessiakssp" --skip-assignment

##Output
APPID="f5046eec-3559-4689-8708-0ca91f2b5a19"
PASSWORD="5e02ea00-bb96-4f25-9f72-ee677008c7f3"

### create the cluster
az aks create \
-g $RG \
-n $AKS_CLUSTER_NAME \
-l $LOCATION \
--node-count 3 \
--network-plugin azure \
--generate-ssh-keys \
--load-balancer-sku standard \
--service-principal $APPID \
--client-secret $PASSWORD

## Connect to the cluster
az aks get-credentials --resource-group $RG --name $AKS_CLUSTER_NAME

##Istio - Check the diffrent profiles
istioctl profile list
istioctl profile dump > ./temp/istio-default-profile.yaml

##Istio - Customize the installation
istioctl manifest generate -f istio-custom/kiali-enable.yaml > ./istio/istio-custom-manifest.yaml

##Deploy Istio
kubectl create ns istio-system
kubectl apply -f ./istio/


#### MS Recommendation
# Specify the Istio version that will be leveraged throughout these instructions
ISTIO_VERSION=1.7.3

curl -sL "https://github.com/istio/istio/releases/download/$ISTIO_VERSION/istioctl-$ISTIO_VERSION-linux-amd64.tar.gz" | tar xz
sudo mv ./istioctl /usr/local/bin/istioctl
sudo chmod +x /usr/local/bin/istioctl

#Init Operator
istioctl operator init

#Install Istio components
kubectl create ns istio-system
kubectl apply -f ./istio
kubectl logs -n istio-operator -l name=istio-operator -f


