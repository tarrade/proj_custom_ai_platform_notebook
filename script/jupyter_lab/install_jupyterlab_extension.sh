### Check which extension exist
jupyter labextension list

# in the base
#Extension 'nbdime-jupyterlab' already up to date
#Extension '@jupyter-widgets/jupyterlab-manager' already up to date
#Extension '@jupyterlab/celltags' already up to date
#Extension '@jupyterlab/git' already up to date

# in the jupyter notebook env
#Extension 'nbdime-jupyterlab' already up to date
#Extension '@jupyterlab/git' already up to date

## Check for update
jupyter lab clean
jupyter labextension update --all
#RUN jupyter lab build

## Update to fix issue with extension of jupyter lab

## Important extension
# The JupyterLab cell tags extension enables users to easily add, view, and manipulate descriptive tags for notebook cells. Will be merged in core.
jupyter labextension install @jupyterlab/celltags@0.2.0 --no-build --debug
# An extension for JupyterLab which allows for live-editing of LaTeX documents.
jupyter labextension install @jupyterlab/latex --no-build  --debug
# A Table of Contents extension for JupyterLab
jupyter labextension install @jupyterlab/toc --no-build --debug
# Display CPU usage in status bar
jupyter labextension install jupyterlab-cpustatus --no-build  --debug
# Create Python Files from JupyterLab
jupyter labextension install jupyterlab-python-file --no-build  --debug
# Jupyterlab extension that shows currently used variables and their values
# !!! version 0.4.0 is making tf to not be working and need a import tensorflow in each cell !!!
#RUN jupyter labextension install @lckr/jupyterlab_variableinspector --no-build  --debug
# Make headings collapsible like the old Jupyter notebook extension and like Mathematica notebooks
jupyter labextension install @aquirdturtle/collapsible_headings --no-build  --debug
# This is a small Jupyterlab plugin to support using various code formatter on the server side and format code cells/files in Jupyterlab
jupyter labextension install @ryantam626/jupyterlab_code_formatter --no-build  --debug
# Provides Conda environment and package access extension from within Jupyter Notebook and JupyterLab
jupyter labextension install jupyterlab_toastify jupyterlab_conda --no-build --debug
# Jupyterlab extension to lint python notebooks and python files in the text editor. Uses flake8 python library for linting
# !!! version 0.5.0 need to be deactivated  -> making notebook instable and crashing at the start !!!
#RUN jupyter labextension install jupyterlab-flake8 --no-build --debug
# Jupyter widgets extension
jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build --debug
# Jupyter TensorBoard extension
jupyter labextension install jupyterlab_tensorboard --no-build --debug

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
# Plotly support with Jupyter Lab (3 extensions)
# Jupyter widgets extension
#RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager@1.1 --no-build --debug
# FigureWidget support
#RUN jupyter labextension install plotlywidget@1.5.1 --no-build --debug
# and jupyterlab renderer support
#RUN jupyter labextension install jupyterlab-plotly@1.5.1 --no-build --debug
# A Jupyter extension for rendering Bokeh content
#RUN jupyter labextension install @bokeh/jupyter_bokeh --debug

# Building
jupyter lab build --debug

# Checking full list
jupyter labextension list

jupyter serverextension enable --py jupyterlab_code_formatter