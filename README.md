# LynxCrew Klicky Macros

## Install:
SSH into you pi and run:
```
wget -O - https://raw.githubusercontent.com/andrewmcgr/klipper_tmc_autotune/main/install.sh | bash
```

then add this to your moonraker.conf:
```
[update_manager klicky]
type: git_repo
channel: dev
path: ~/klicky
origin: https://github.com/LynxCrew/Klicky.git
managed_services: klipper
primary_branch: main
install_script: install.sh
```
