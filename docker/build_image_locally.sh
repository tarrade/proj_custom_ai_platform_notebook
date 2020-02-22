# create test folder
cd ../
mkdir test-docker
pwd

# copy config files localy
cp docker/derived-pytorch-cpu/Dockerfile test-docker/.

cp env/base.yml test-docker/.

cp script/bucket_gcp/scripts/.condarc test-docker/.
cp script/bucket_gcp/scripts/pip.conf test-docker/.
cp script/bucket_gcp/scripts/pip.conf test-docker/.
cp script/bucket_gcp/scripts/.gitconfig test-docker/.


cd test-docker

# locally drop the line with clean up of conda packages
sed -i.bak  '/RUN conda clean -a -y/d' Dockerfile

# drop --debug option for jupyter lab when running locally
#sed -i.bak  's/--debug//g' Dockerfile

echo "build the docker image"
docker build -f Dockerfile .

cd ../docker
