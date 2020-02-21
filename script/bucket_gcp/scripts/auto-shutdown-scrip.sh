#!/bin/bash
# Checking the type of machine
cat /etc/os-release
lsb_release -a
uname -r

# Installling rge auto shutdown script
echo "copying file from gs to the VM"
gsutil cp gs://custom-ai-platform-notebook/scripts/auto-shutdown/ashutdown /usr/local/bin/
gsutil cp gs://custom-ai-platform-notebook/scripts/auto-shutdown/ashutdown.service /lib/systemd/system/
chmod +x /usr/local/bin/ashutdown
ls -la /lib/systemd/system/ashutdown.service
echo "installing sysstat bc -y -q"
apt-get install sysstat bc -y -q
echo "executing systemctl --no-reload --now enable /lib/systemd/system/ashutdown.service"
systemctl --no-reload --now enable /lib/systemd/system/ashutdown.service
