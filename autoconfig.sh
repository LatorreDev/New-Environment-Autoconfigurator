#!/usr/bin/env bash
# Script for a new machine configuration

#custom_colors
COLOR='\e['
RED='31m'
BLUE='34m'
GREEN='32m'
YELLOW='33m'
# Efects
BOLD='1;'
BLINK='5;'
END='\e[0m'
#FULLLINE= "$COLOR$BOLD$BLINK$GREEN ******************* $END"

install_tools(){
echo -e "$COLOR$BOLD$GREEN Installing base $END"
sleep 1
sudo pacman -S wget curl git vim zsh tcpdump nmap python3 python-pip gcc --noconfirm
# Set zsh as default
wget  https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
sudo chmod u+x install.sh && ./install.sh --unattended
rm install.sh
chsh -s $(which zsh)
# Set pycodestyle
sudo -H python3 -m pip install pycodestyle
sudo -H python3 -m pip install shellcheck-py
# Set Betty Coding style
if [ -d Betty]; then
	rm -rf Betty
fi
git clone https://github.com/holbertonschool/Betty.git
cd Betty
sudo chmod u+x install.sh && sudo ./install.sh
cd ..
rm -rf Betty/
# set vim configuration
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
wget https://raw.githubusercontent.com/LatorreDev/MyVimConfig/master/vimrc
if [! -d ~/.vimrc]; then
	touch ~/.vimrc
fi
cat vimrc >> ~/.vimrc
echo ":source %" > configvim
echo ":PluginInstall" >> configvim
echo ":q!" >> configvim
echo ":q!" >> configvim
vim -s configvim ~/.vimrc
rm configvim
rm vimrc
echo -e "$COLOR$BOLD$GREEN Base installed $END"
sleep 1
}

update_databases(){
echo -e "$COLOR$BLINK$RED Updating Databases $END"
sudo pacman -Syy
echo -e "$COLOR$BLINK$GREEN Databases Updated $END"
sleep 1
}

upgrade_archlinux(){
echo -e "$COLOR$BLINK$BOLD$RED Upgrading Archlinux $END"
sudo pacman -Syu --noconfirm
sleep 1
}

github_config(){
read -e -r -p "Give me your github email: " email
read -e -r -p "Give me your github username: " username
sleep 1
echo -e "$COLOR$BOLD$GREEN Setting vim as your default text editor $END"
sleep 1
echo -e "$COLOR$BOLD$GREEN Setting your github credentials $END"
sleep 1
git config --global user.email $email
git config --global user.name $username
sleep 1
echo -e "$COLOR$BOLD$GREEN This is  your github config $END"
git config --list
sleep 2
}

menu(){
while true;do
	
	echo -e "$COLOR$BOLD$GREEN Welcome to the Autoconfigurator $END"
	options=("Update Arch Linux Databases"
		"Upgrade Arch Linux"
		"Install Tools"
		"Github Config"
		"Exit"
	)

	select opt in "${options[@]}"
	do
		case $opt in

		"Update Arch Linux Databases")
		update_databases
		break
		;;

		"Upgrade Arch Linux")
		upgrade_archlinux
		break
		;;

		"Install Tools")
		install_tools
		break
		;;

		"Github Config")
		github_config
		break
		;;

		"Exit")
		echo -e "$COLOR$RED Goodbye then $END"
		sleep 1
		break 2
		zsh
		;;

		*) echo -e "$COLOR$BOLD$RED opps wrong option, try again ;) $END"
		sleep 1
		break
		;;

		esac
	done
done
}

menu
