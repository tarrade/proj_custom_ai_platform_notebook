# Specify the base image and tag
FROM gcr.io/deeplearning-platform-release/pytorch-cpu:m40

# Checking the type of machine
RUN cat /etc/os-release
RUN lsb_release -a
RUN uname -r

# Install htop
RUN apt-get update
RUN apt-get install htop

# Checking that the right shell is used in the image the build and later when the container is launched from the image
RUN echo $0
# active in the shell
SHELL ["/bin/bash", "-c"]
# active in the terminla later
ENV SHELL /bin/bash
RUN echo $0

## Creating conda env
# Adding the environment files in the docker image
ADD base.yml base.yml

# Update conda manager
RUN conda update -n base conda -y

# Define a folder to store env
RUN mkdir -p /root/.conda-env/
RUN mkdir -p /home/.conda-env/
RUN mkdir -p /home/.conda-pkg/
RUN mkdir -p /home/.jupyter_autosave/

# Create config files
RUN conda config --add channels conda-forge
RUN conda config --add envs_dirs /root/.conda-env/

# Update conda envs
RUN conda env update --file base.yml

# Create env if needed
#RUN conda env create -f environment.yml

# Checking configuration and new created envs
RUN conda config --show
RUN conda config --show-sources
RUN conda config --show envs_dirs

RUN conda info
RUN conda info -e
RUN conda env list
RUN conda list

RUN ls -la /root/.conda-env/

# checking display conda env in notebook
RUN conda list nb_conda_kernels
RUN conda list notebook
RUN conda list ipykernel

RUN jupyter kernelspec list
RUN jupyter --paths

## Clean all downloaded packages
RUN conda clean -a -y

### Check which extension exist
RUN jupyter labextension list
#Extension 'nbdime-jupyterlab' already up to date
#Extension '@jupyter-widgets/jupyterlab-manager' already up to date
#Extension '@jupyterlab/celltags' already up to date
#Extension '@jupyterlab/git' already up to date

## Check for update
RUN jupyter lab clean
RUN jupyter labextension update --all
RUN jupyter lab build

## Update to fix issue with extension of jupyter lab
### already on the docker image
#RUN jupyter labextension install nbdime-jupyterlab --debug
#RUN jupyter labextension update @jupyter-widgets/jupyterlab-manager --debug
#RUN jupyter labextension update @jupyterlab/celltags --debug

## Important extension
# An extension for JupyterLab which allows for live-editing of LaTeX documents.
RUN jupyter labextension install @jupyterlab/latex --debug
# A Table of Contents extension for JupyterLab
RUN jupyter labextension install @jupyterlab/toc --debug
# Display CPU usage in status bar
RUN jupyter labextension install jupyterlab-cpustatus --debug
# Create Python Files from JupyterLab
RUN jupyter labextension install jupyterlab-python-file --debug
# Jupyterlab extension that shows currently used variables and their values
RUN jupyter labextension install @lckr/jupyterlab_variableinspector --debug
# Make headings collapsible like the old Jupyter notebook extension and like Mathematica notebooks
RUN jupyter labextension install @aquirdturtle/collapsible_headings --debug
# This is a small Jupyterlab plugin to support using various code formatter on the server side and format code cells/files in Jupyterlab
RUN jupyter labextension inst26/jupyterlab_code_formatter @ryantam6 --debug
# Plotly support with Jupyter Lab (3 extensions)
# Jupyter widgets extension
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager@1.1 --no-build --debug
# FigureWidget support
RUN jupyter labextension install plotlywidget@1.5.1 --no-build --debug
# and jupyterlab renderer support
RUN jupyter labextension install jupyterlab-plotly@1.5.1 --no-build --debug
# A Jupyter extension for rendering Bokeh content
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager --debug
RUN jupyter labextension install @bokeh/jupyter_bokeh --debug
# Provides Conda environment and package access extension from within Jupyter Notebook and JupyterLab
RUN jupyter labextension install jupyterlab_toastify jupyterlab_conda --debug
# Jupyterlab extension to lint python notebooks and python files in the text editor. Uses flake8 python library for linting
RUN jupyter labextension install jupyterlab-flake8 --debug

## Old extensions/not so important
# A JupyterLab extension for accessing GitHub repositories
#RUN jupyter labextension install @jupyterlab/github --debug
# This extension adds a few Jupytext commands to the command palette. Use these to select the desired ipynb/text pairing for your notebook
#RUN jupyter labextension install jupyterlab-jupytext --debug
# JupyterLab extension mimerenderer to render HTML files in IFrame Tab
#RUN jupyter labextension install @mflevine/jupyterlab_html
# A spell checker extension for markdown cells in jupyterlab notebooks
#RUN jupyter labextension install @ijmbarr/jupyterlab_spellchecker
# A JupyterLab extension for standalone integration of drawio / mxgraph into jupyterlab
#RUN jupyter labextension install jupyterlab-drawio --debug


RUN jupyter serverextension enable --py jupyterlab_code_formatter
RUN jupyter lab build
RUN jupyter labextension list

# Checking more info
RUN id
RUN whoami
RUN cat /etc/passwd
RUN cat /etc/group

# Running some checks
RUN echo $HOME

# set the right permission
RUN chmod +x /entrypoint.sh

# Activate conda
RUN conda init bash && . /root/.bashrc && conda info -e # && conda activate base

## !!!!
## !!!! NO pip, conda, git command below because of proxy config !!!!
## !!!!

## Configuration related to the entrerpise proxy server
# Setup the proxy server for conda
ADD .condarc /.condarc
ENV CONDARC /.condarc

# drop local conda-env canal
RUN conda config --remove envs_dirs /root/.conda-env/

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

# Copy env if they exist from /root to /home
RUN sed -i '1 a cp -r /root/.conda-env/env* /home/.conda-env/.' /entrypoint.sh
RUN cat  /entrypoint.sh

# Running some checks about kernels
RUN sed -i '1 a if [ -e /home/config.sh ]\nthen\n    source /home/config.sh\nfi\njupyter serverextension list\nconda info\nconda list nb_conda_kernels\nconda env list\nprintenv' /run_jupyter.sh
RUN cat  /run_jupyter.sh

# Adding option in jupyter notebook: display conda env, display hidden files
RUN sed -i -e "\$ac.NotebookApp.kernel_spec_manager_class = 'nb_conda_kernels.manager.CondaKernelSpecManager'" /root/.jupyter/jupyter_notebook_config.py
RUN sed -i -e "\$ac.ContentsManager.allow_hidden = True" /root/.jupyter/jupyter_notebook_config.py
RUN sed -i -e "\$ac.NotebookApp.notebook_dir = '/home'" /root/.jupyter/jupyter_notebook_config.py
RUN sed -i -e "\$ac.FileCheckpoints.checkpoint_dir = '/home/.jupyter_autosave'" /root/.jupyter/jupyter_notebook_config.py
RUN cat /root/.jupyter/jupyter_notebook_config.py

# Add execution of custom scripts it is exists
RUN sed -i -e "\$aif [ -e /home/config.sh ]\nthen\n    source /home/config.sh\nfi\n" /etc/skel/.profile
RUN cat /etc/skel/.profile

# Add execution of custom scripts it is exists
RUN sed -i -e "\$aif [ -e /home/config.sh ]\nthen\n    source /home/config.sh\nfi\n" /root/.bashrc
RUN cat /root/.bashrc

# Define entry points
ENTRYPOINT ["/entrypoint.sh", "/run_jupyter.sh"]

# Don't use it
#WORKDIR /home/
