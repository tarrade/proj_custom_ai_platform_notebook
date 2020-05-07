#!/bin/bash

echo "This is the start of the activate_port_tensorboard.sh script"

# Adding port forwarding for TensorBoard on port 6006
sed -i '/docker run -d/a\    -p 127.0.0.1:6006:6006/tcp \\' /opt/deeplearning/bin/load_container.sh
cat /opt/deeplearning/bin/load_container.sh

echo "This is the end of the activate_port_tensorboard.sh script"