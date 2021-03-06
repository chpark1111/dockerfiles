export USER_NAME="$(whoami)"
if [ -e "../.dotfiles" ] ; then
    echo ".dotfiles already exist"
else
    git clone https://github.com/chpark1111/my_dotfiles.git /home/$USER_NAME/.dotfiles;cd /home/$USER_NAME/.dotfiles;
    ./install.sh
fi
rm /usr/bin/python3;ln -s python3.9 /usr/bin/python3

pip install --upgrade pip setuptools wheel
pip install opencv-python
pip install -r requirements3.9.txt
pip install torch==1.11.0+cu113 torchvision==0.12.0+cu113 torchaudio==0.11.0+cu113 -f https://download.pytorch.org/whl/cu113/torch_stable.html

service ssh start
