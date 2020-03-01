#!/bin/bash

echo "This is the start of the startup script"
sudo ls -la .
cat /opt/deeplearning/bin/attempt-register-vm-on-proxy.sh  | grep "SHIM"
sed -i 's/SHIM_WEBSOCKETS=false/SHIM_WEBSOCKETS=true/g' /opt/deeplearning/bin/attempt-register-vm-on-proxy.sh
echo "After the transformation"
cat /opt/deeplearning/bin/attempt-register-vm-on-proxy.sh  | grep "SHIM"
echo "This is the end of the startup script"