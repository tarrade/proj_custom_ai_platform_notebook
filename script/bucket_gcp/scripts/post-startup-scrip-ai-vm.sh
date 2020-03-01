#!/bin/bash

# all post startup scripts

# activate websocket_shim for AI Platform notebook
# Installling the auto shutdown script
echo "copying file from gs to the VM"
gsutil cp gs://custom-ai-platform-notebook/scripts/activate_websocket_shim_notebook.sh .
sudo bash activate_websocket_shim_notebook.sh

# activate auto-shutdown/ashutdown
gsutil cp gs://custom-ai-platform-notebook/scripts/auto-shutdown-scrip.sh .
sudo bash auto-shutdown-scrip.sh