rpm -qa --qf "%{NAME}\n" | sort > ~/dotfiles/rpm.bak
sudo yum install $(cat ~/dotfiles/rpm.bak)
