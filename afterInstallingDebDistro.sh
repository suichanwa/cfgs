sudo apt-get update
sudo apt-get upgrade

1sudo apt-get install build-essential libx11-dev libxinerama-dev sharutils suckless-tools libxft-dev stterm
cd /usr/local/src
sudo wget http://dl.suckless.org/dwm/dwm-6.0.tar.gz
sudo tar xvzf dwm-6.0.tar.gz
chown -R `id -u`:`id -g` dwm-6.0
cd dwm-6.0
