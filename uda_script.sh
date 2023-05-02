az vmss list-instance-connection-info --resource-group uda-proj4-rg --name udacity-vmss
ssh -p 50000 udacityadmin@4.193.62.160
ssh -p 50003 udacityadmin@4.193.62.160

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