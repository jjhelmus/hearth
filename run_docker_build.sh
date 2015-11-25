#!/usr/bin/env bash

REPO_ROOT=$(cd "$(dirname "$0")/.."; pwd;)
IMAGE_NAME="pelson/obvious-ci:latest_x64"

cat << EOF | docker run -i \
                        -v ${REPO_ROOT}/recipe:/recipe \
                        -a stdin -a stdout -a stderr \
                        $IMAGE_NAME \
                        bash || exit $?

unset LANG
conda clean --lock

# update conda
conda update --yes conda

# install build tools
conda install --yes conda-build jinja2 anaconda-client

# debugging
conda info
ls
pwd

# build packages
conda build -q -c jjhelmus --python 2.7 --numpy 1.10 recipe

# upload packages
cp ~/miniconda3/conda-bld/*/*.tar.bz2 .
ls *.tar.bz2
#anaconda -t $TOKEN upload *.tar.bz2
EOF
