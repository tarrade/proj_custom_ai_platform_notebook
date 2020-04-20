#!/bin/bash

echo "This is the start of the remove_existing_payload.sh script"

# Adding port forwarding for TensorBoard on port 6006
sed -i '/docker run -d/i\docker rm "/payload-container" || printf "no existing payload container to be deleted"\' /opt/deeplearning/bin/load_container.sh
cat /opt/deeplearning/bin/load_container.sh

echo "This is the end of the remove_existing_payload.sh a script"