# Dymo 5XX driver installer for linux
# Original drivers: https://github.com/dymosoftware/Drivers
#                   https://help.dymo.com/s/article/Can-I-install-my-LabelWriter-on-other-systems-than-Windows-and-MacOS?language=en_US
#
# Run bash ./install.sh without sudo.

# Packages

sudo apt update
sudo apt install libboost-all-dev libcups2 libcups2-dev libcupsimage2-dev automake-1.16

# Unzip
ls 5xx-drivers.zip.b64
if [ "$?" == "2" ]; then
  echo -e "\e[31m5xx-drivers.zip.b64 not found\e[0m"
  exit 2
fi

cat 5xx-drivers.zip.b64 | base64 -d > 5xx-drivers.zip
unzip 5xx-drivers.zip

cd LW5xx\ Linux\ 1.4.3

# Configure and make
autoreconf -f -i
./configure
confexit=$?
if [ "$confexit" != "0" ]; then
  echo -e "\e[31m./configure exited with code $confexit.\e[0m"
  exit 1
fi
make
makeexit=$?
if [ "$makeexit" != "0" ]; then
  echo -e "\e[31mmake exited with code $makeexit.\e[0m"
  exit 1
fi

# Install
sudo make install
makeinstallexit=$?
if [ "$makeinstallexit" != "0" ]; then
  echo -e "\e[31msudo make install exited with code $makeinstallexit.\e[0m"
  exit 1
fi

cd ..

# Clean up
rm 5xx-drivers.zip
rm -r LW5xx\ Linux\ 1.4.3

# Alert
echo -e '\e[92mInstallation done! You can add the printer through the printers interface.\e[0m'
zenity --info --title "Dymo Driver Installer" --text "Installation Done\!\n\nYou can now add the Dymo label printer\nthrough the printers interface." --no-wrap & 

