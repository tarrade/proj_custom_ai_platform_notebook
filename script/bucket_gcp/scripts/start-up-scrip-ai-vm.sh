#!/bin/bash

# Print env variable and check
echo "checking if env variables exist ..."
printenv
echo "checking if .vm_created exist ..."
ls -la

if [ ! -f /.vm_created ]; then
  echo "config and stackdriver are not yet installed"

  # Add execution of custom scripts it is exists for existing user /home/*/etc/skel/.profile
  find /home -name ".profile" -exec sed -i -e "\$aif [ -e /home/config.sh ]\nthen\n    source /home/config.sh\nfi\n" {} \;

  # Add execution of custom scripts it is exists in the skeleton  /etc/skel/.profile
  sed -i -e "\$aif [ -e /home/config.sh ]\nthen\n    source /home/config.sh\nfi\n" /etc/skel/.profile
  cat /etc/skel/.profile

  # Install the Stackdriver Monitoring agent
  curl -sSO https://dl.google.com/cloudagents/install-monitoring-agent.sh
  sudo bash install-monitoring-agent.sh

  # Install the Stackdriver Logging agent
  curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh
  sudo bash install-logging-agent.sh --structured

  # created a file to indicate the VM was created
  touch /.vm_created
else
  echo "everything already exist ..."
fi