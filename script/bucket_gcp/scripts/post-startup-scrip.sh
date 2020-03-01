#!/bin/bash

# all post startup scripts

# activate websocket_shim for AI Platform notebook
sudo bash activate_websocket_shim_notebook.sh

# activate auto-shutdown/ashutdown
sudo bash auto-shutdown-scrip.sh