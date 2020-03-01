#!/bin/bash

# all post startup scripts
echo "starting the post-startup script"

# activate websocket_shim for AI Platform notebook
# Installling the auto shutdown script
echo "copying activate_websocket_shim_notebook.sh from gs to the VM"
gsutil cp gs://custom-ai-platform-notebook/scripts/activate_websocket_shim_notebook.sh .
sudo bash activate_websocket_shim_notebook.sh

# activate auto-shutdown/ashutdown
echo "copying auto-shutdown-scrip.sh from gs to the VM"
gsutil cp gs://custom-ai-platform-notebook/scripts/auto-shutdown-script.sh .
sudo bash auto-shutdown-script.sh

echo "list of files"
ls -la