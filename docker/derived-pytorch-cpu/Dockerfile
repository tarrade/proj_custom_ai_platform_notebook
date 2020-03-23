# Specify the base image and tag
ARG TAG=43

#FROM gcr.io/deeplearning-platform-release/pytorch-cpu:m42 #old style image
#FROM gcr.io/deeplearning-platform-release/pytorch-cpu:m43 #new style image with Anaconda by default
FROM gcr.io/deeplearning-platform-release/pytorch-cpu:m$TAG

# trick to have the tag after the from
ARG TAG
RUN echo m${TAG}

# Checking that the right shell is used in the image the build and later when the container is launched from the image
RUN echo $0
# active in the shell
SHELL ["/bin/bash", "-c"]

# active in the terminla later
#ENV SHELL /bin/bash
RUN echo $0

# Checking the type of machine
RUN cat /etc/os-release
RUN lsb_release -a
RUN uname -r

# Install htop
RUN apt-get update
RUN apt-get install htop

## Creating conda env
# Adding the environment files in the docker image
ADD jupyter-notebook.yaml jupyter-notebook.yaml

# Update conda manager
RUN conda update -n base conda -y

# Define a folder to store env
#RUN mkdir -p /root/.conda-env/
RUN mkdir -p /home/.conda-env/
RUN mkdir -p /home/.conda-pkg/
RUN mkdir -p /home/.jupyter_autosave/

# Create config files
RUN conda config --add channels conda-forge
# Create env if needed
RUN conda env create -f jupyter-notebook.yaml

# Checking configuration and new created envs
RUN conda config --show
RUN conda config --show-sources
RUN conda config --show envs_dirs

RUN conda info
RUN conda info -e
RUN conda env list
RUN conda list

#RUN ls -la /root/.conda-env/

# checking display conda env in notebook
RUN conda list nb_conda_kernels
RUN conda list notebook
RUN conda list ipykernel

RUN jupyter kernelspec list
RUN jupyter --paths

## Clean all downloaded packages
RUN conda clean -a -y

# Activate conda
RUN conda init bash
RUN conda info -e
SHELL ["conda", "run", "-n", "jupyter-notebook", "/bin/bash", "-c"]

# Check which env is activated
RUN conda info -e
RUN conda info
RUN conda list

# Trick to fix an issue with Black and temp folders that are created too late: 19.10b0
RUN python -c "import logging; logging.basicConfig(level=logging.INFO); import black"
RUN touch /black.py
RUN sed -i "import pandas as pd\nprint(pd.__version__)"  /black.py
RUN black /black.py
RUN python -c "import logging; logging.basicConfig(level=logging.INFO); import black"

# Not working
#RUN conda init bash && conda info -e &&  . /root/miniconda3/etc/profile.d/conda.sh && conda activate jupyter-notebook
#RUN conda activate jupyter-notebook

# installing jupyter lab extension
ADD install_jupyterlab_extension.sh install_jupyterlab_extension.sh
RUN cat /install_jupyterlab_extension.sh
RUN . /install_jupyterlab_extension.sh

# Checking more info
RUN id
RUN whoami
RUN cat /etc/passwd
RUN cat /etc/group

# Running some checks
RUN echo $HOME

## !!!!
## !!!! NO pip, conda, git command below because of proxy config !!!!
## !!!!

## Configuration related to the entrerpise proxy server
# Setup the proxy server for conda
ADD .condarc /.condarc
ENV CONDARC /.condarc

# Setup the proxy server for pip
ADD pip.conf /pip.conf
ENV PIP_CONFIG_FILE /pip.conf

# Setup the proxy server for git
ADD .gitconfig /root/.gitconfig
# Check that the config file was created properly
RUN git config --list

# Adding the config file to read entrerise Github
#RUN mkdir -p /root/.ssh/
#ADD known_hosts /root/.ssh/known_hosts
#ADD id_rsa /root/.ssh/id_rsa
#ADD config /root/.ssh/config

# Create default black-theme
RUN echo -e "{\n  \"@jupyterlab/apputils-extension:themes\": {\n    \"theme\": \"JupyterLab Dark\"\n  }\n}"  > ${DL_ANACONDA_HOME}/envs/jupyter-notebook/share/jupyter/lab/settings/overrides.json
RUN cat ${DL_ANACONDA_HOME}/envs/jupyter-notebook/share/jupyter/lab/settings/overrides.json
RUN ls -la ${DL_ANACONDA_HOME}/envs/jupyter-notebook/share/jupyter/lab/settings/overrides.json

# Checking some other config file from jupyter lab
RUN cat /root/.ipython/profile_default/ipython_kernel_config.py

# Running some checks about kernels
RUN sed -i '1 a if [ -e /home/config.sh ]\nthen\n    source /home/config.sh\nfi\njupyter serverextension list\nconda info\nconda list nb_conda_kernels\nconda env list\nprintenv\nconda info -e\njupyter labextension list\nprintenv' /run_jupyter.sh
RUN if [ ${TAG}>42 ] ; then sed -i "s+\${DL_ANACONDA_HOME}/bin/++g"  /run_jupyter.sh ; else sed -i "s+/root/miniconda3/bin/++g"  /run_jupyter.sh ; fi
#RUN sed -i "s+/root/miniconda3/bin/++g"  /run_jupyter.sh     #m42
#RUN sed -i "s+\${DL_ANACONDA_HOME}/bin/++g"  /run_jupyter.sh #m43
RUN cat  /run_jupyter.sh

# Adding option in jupyter notebook: display conda env, display hidden files
RUN cat /root/.jupyter/jupyter_notebook_config.py
RUN sed -i.bak -e "\$ac.NotebookApp.kernel_spec_manager_class = \x27nb_conda_kernels.manager.CondaKernelSpecManager\x27" /root/.jupyter/jupyter_notebook_config.py
RUN sed -i -e "\$ac.ContentsManager.allow_hidden = True" /root/.jupyter/jupyter_notebook_config.py
#RUN sed -i.back "\$ac.NotebookApp.notebook_dir =  \x27/home \x27" /root/.jupyter/jupyter_notebook_config.py
RUN sed -i.bak "\$ac.FileCheckpoints.checkpoint_dir = \x27/home/.jupyter_autosave\x27" /root/.jupyter/jupyter_notebook_config.py
RUN cat /root/.jupyter/jupyter_notebook_config.py

# Set the right permission
RUN chmod +x /entrypoint.sh
# Copy env if they exist from /root to /home
#RUN sed -i "1 a conda config --remove envs_dirs /root/.conda/envs" /entrypoint.sh
RUN sed -i "1 a conda info" /entrypoint.sh
RUN sed -i "1 a conda info --envs" /entrypoint.sh
RUN sed -i "1 a printenv" /entrypoint.sh
#RUN sed -i '1 a cp -r /root/.conda-env/* /home/.conda-env/.' /entrypoint.sh
RUN sed -i "s/conda activate base/conda activate jupyter-notebook/g" /entrypoint.sh
RUN cat  /entrypoint.sh

# Add execution of custom scripts it is exists
RUN sed -i -e "\$aif [ -e /home/config.sh ]\nthen\n    source /home/config.sh\nfi\n" /etc/skel/.profile
RUN cat /etc/skel/.profile

# Add execution of custom scripts it is exists
RUN sed -i -e "\$aif [ -e /home/config.sh ]\nthen\n    source /home/config.sh\nfi\n" /root/.bashrc
RUN cat /root/.bashrc

# drop local conda-env canal (at the very end to avoid clashes)
#RUN conda config --remove envs_dirs /root/.conda-env/
#RUN conda config --add envs_dirs /root/.conda-env/
RUN conda info

# Define entry points
ENTRYPOINT ["/entrypoint.sh", "/run_jupyter.sh"]

WORKDIR /home/
