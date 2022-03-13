# cfgs


sudo apt install git -y
sudo dnf in git -y

git clone https://github.com/suichanwa/cfgs

sudo chmod 555 debDistroConfigureScript.sh
sudo chmod 555 rpmDistroConfigureScript.sh

./debDistroConfigureScript.sh

//or

./rpmDistroConfigureScript.sh
