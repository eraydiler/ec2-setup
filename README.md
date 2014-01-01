ec2-setup
=========

git config --global user.name $USERNAME
git config --global user.email $EMAIL

ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub

git clone git@github.com:eraydiler/ec2-setup.git

sudo chmod a+x install.sh install2.sh
