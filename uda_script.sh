az vmss list-instance-connection-info --resource-group acdnd-c4-project --name udacity-vmss
ssh -p 50000 udacityadmin@20.237.144.247
ssh -p 50002 udacityadmin@20.237.144.247

git clone https://github.com/HuuThang-1402/Udacity-Enhancing-Applications-AzureDev.git
git checkout Deploy_to_VMSS
# Update sudo
sudo apt update     
# Install Python 3.7
sudo apt install python3.7      
python3 --version
# Install pip
sudo -H pip3 install --upgrade pip
# Install and start Redis server. Refer https://redis.io/download for help.
wget https://download.redis.io/releases/redis-6.2.4.tar.gz
tar xzf redis-6.2.4.tar.gz
cd redis-6.2.4
make
# Ping your Redis server to verify if it is running. It will return "PONG"
redis-cli ping
# The server will start after make. Otherwise, use
src/redis-server           
# Install dependencies - necessary Python packages - redis, opencensus, opencensus-ext-azure, opencensus-ext-flask, flask
cd ..      
pip install -r requirements.txt
# Run the app from the Flask application directory
cd azure-vote/      
python3 main.py

# Change the ACR name in the commands below.
# Assuming the acdnd-c4-project resource group is still available with you
# ACR name should not have upper case letter
az acr create --resource-group acdnd-c4-project-aks-eastus --name myacr202356 --sku Basic
# Log in to the ACR
az acr login --name myacr202356
# Get the ACR login server name
# To use the azure-vote-front container image with ACR, the image needs to be tagged with the login server address of your registry. 
# Find the login server address of your registry
az acr show --name myacr202356 --query loginServer --output table
# Associate a tag to the local image. You can use a different tag (say v2, v3, v4, ....) everytime you edit the underlying image. 
docker tag azure-vote-front:v1 myacr202356.azurecr.io/azure-vote-front:v1
# Now you will see myacr202356.azurecr.io/azure-vote-front:v1 if you run "docker images"
# Push the local registry to remote ACR
docker push myacr202356.azurecr.io/azure-vote-front:v1
# Verify if your image is up in the cloud.
az acr repository list --name myacr202356 --output table
# Associate the AKS cluster with the ACR
az aks update -n udacity-cluster -g acdnd-c4-project-aks-eastus --attach-acr myacr202356

# Get the ACR login server name
az acr show --name myacr202356 --query loginServer --output table

# Deploy the application. Run the command below from the parent directory where the *azure-vote-all-in-one-redis.yaml* file is present. 
kubectl apply -f azure-vote-all-in-one-redis.yaml
kubectl set image deployment azure-vote-front azure-vote-front=myacr202356.azurecr.io/azure-vote-front:v1
# Test the application at the External IP
# It will take a few minutes to come alive. 
kubectl get service
# Check the status of each node
kubectl get pods
# Push your local changes to the remote Github repo, preferably in the Deploy_to_AKS branch

az account set --subscription "15ddb23d-5e27-4c2c-83e2-4c57f375ff8b"
az aks get-credentials --resource-group acdnd-c4-project-aks-eastus --name myacr202356
gcloud container clusters get-credentials myacr202356 --region=acdnd-c4-project-aks-eastus
az aks get-credentials --resource-group acdnd-c4-project-aks-eastus --name udacity-cluster --verbose