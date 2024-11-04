variable1=(alsa-utils linux-firmware arch-install-scripts dracut archiso b43-fwcutter base bind bolt brltty broadcom-wl-dkms btrfs-progs cloud-init cryptsetup ddrescue dhclient dhcpcd diffutils dmidecode dmraid dnsmasq dosfstools e2fsprogs efibootmgr espeak-ng ethtool exfat-progs fatresizefs fsarchiver gnu-netcat gpart gpm gptfdisk grub hdparm intel-ucode irssi iwd ldns less lftp libfido2 libusb-compat linux linux-headers linux-atmlinux-firmware linux-firmware-marvell livecd-sounds lscs lvm2 man-db man-pages mc mdadm mkinitcpio mkinitcpio-archiso mkinitcpio-nfs-utils modemmanager mtools nano nbd ndisc6 nfs-utils nilfs-utils nmap ntfs-3g nvme-cli open-iscsi open-vm-tools openconnect openpgp-card-tools openssl openvpn partclone parted partimage pcsclite ppp pptpclient pv qemu-guest-agent reflector rp-pppoe rsync sdparm sequoia-sqsg3_utils smartmontools sof-firmware squashfs-tools sudo syslinux systemd-resolvconf tcpdump testdisk tpm2-tools tpm2-tss udftools usb_modeswitch usbmux usbutils virtualbox-guest-utils-nox vpnc wireless-regdb wireless_tools wvdial xl2tpd zsh cinnamon cinnamon-control-center cinnamon-desktop cinnamon-menus cinnamon-session cinnamon-settings-daemon cjsmuffin nemo xdg-desktop-portal-xapp xdg-user-dirs-gtk gnome-terminal xorg lightdm lightdm-gtk-greeter pulseaudio pavucontrol firefox qt6-multimedia-ffmpeg qt6-multimedia-gstreamer qca-qt6 qt6-5compat qt6-base qt6-declarative qt6-doc qt6-shadertools qt6-svg qt6-tools qt6-translations qt6-wayland gedit gnome-system-monitor mate-icon-theme-faenza numix-themes libkf6crash-devel glucalamaresoscalamares-config gnome-disk-utility fastfetch cinnamon-configs webapp-manager cups kpmcoreelectron31)
input=$variable1
deplist=sudo pacman -Qi $input | grep -i "Depends On" |  cut -d':' -f2 | sed 's/ /\ /g'

## Testing upate

for input in "${variable1[@]}" ; do
  echo "$input already exists. Recreating Directory, pulling, and building $input" ;
  sudo pacman -Syy $deplist --noconfirm ;
  sudo pacman -S --needed $(grep -E '^(make)?depends=' PKGBUILD | sed -e 's/^[^(]*(//' -e 's/)//' | tr -d "'" | tr ' ' '\n' | grep -v '^$' | sed 's/[<=>].*$//') --noconfirm ;
  pkgctl repo clone $input ;

  if [ -d keys ] ; then
    echo "Importing keys for $input";
    cd $input/keys/pgp/ || exit 1 ;
    gpg --import ./*.asc ;
    cd ../../ || exit 1 ;
  else
    echo "There are no keys for $input, skipping keys"; 
    cd $input ;
  fi

  echo "There is no $input, grabbing now and building." ;
  makepkg ;
 # mv ./*.pkg.tar.zst "../transitionalpackagerepo/$(date -I)/" ;
 # cd ../transitionalpackagerepo/ ;
 # echo "Pushing $input to Repo" ;
 # git remote rm origin ;
 # git remote add origin ssh://git@darrengames.ddns.net:30009/Sprungles/transitionalpackagerepo.git ;
 # git pull ;
 # git add . ;
 # git commit -m "Pushing $input" ;
 # git push --set-upstream origin main ;
 # cd ../ ;
 # echo 'Cleaning Up Workspace';
 # rm -rf $input/ ;
done


