# create test folder
cd ../
mkdir test-docker
pwd

# copy file localy
cp docker/derived-pytorch-cpu/Dockerfile test-docker/.
cp env/base.yml test-docker/.
cp env/environment.yml test-docker/.
cp env/environment_gcp.yml test-docker/.
cp env/jupyter-notebook.yml test-docker/.

cd test-docker

echo "build the docker image"
docker build -f Dockerfile .
