#!/bin/bash

echo "This is the start of the startup script"

# Adding port forwarding for TensorBoard on port 6006
sed -e '/docker run -d/a\    -p 6006:6006 \\' /opt/deeplearning/bin/load_container.sh
cat /opt/deeplearning/bin/load_container.sh

echo "This is the end of the startup script"