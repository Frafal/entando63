# entando63

'''
multipass launch --name ubuntu-entando --cpus 8 --mem 8G --disk 20G
multipass shell ubuntu-entando
sudo apt update && sudo apt upgrade
git clone https://github.com/Frafal/entando63.git
cd entando63
sed -i "s/UTENTE/$USER/" INSTALL-okd.sh
sudo chmod +x INSTALL-okd.sh
sudo ./INSTALL-okd.sh
'''


