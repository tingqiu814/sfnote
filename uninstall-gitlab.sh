#/bin/bash 
gitlab-ctl uninstall
gitlab-ctl cleanse
gitlab-ctl remove-accounts
dpkg -P gitlab-ce
