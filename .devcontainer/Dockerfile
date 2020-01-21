#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

FROM python:3

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

ENV PIP_TARGET=/usr/local/share/pip-global
ENV PYTHONPATH=${PYTHONPATH}:${PIP_TARGET}
ENV PATH=${PATH}:${PIP_TARGET}/bin

# Uncomment the following COPY line and the corresponding lines in the `RUN` command if you wish to
# include your requirements in the image itself. It is suggested that you only do this if your
# requirements rarely (if ever) change.
# COPY requirements.txt /tmp/pip-tmp/

# Configure apt and install packages
RUN apt-get update \

    # Ubuntu packages
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    && apt-get -y install git iproute2 procps lsb-release sudo \

    # Python packages
    && pip --disable-pip-version-check --no-cache-dir install pylint mypy pytest ipython jupyter \
    && mkdir -p /usr/local/share/pip-global \
    && chown ${USERNAME}:root /usr/local/share/pip-global \

    # Cleanup
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

COPY .devcontainer/devconfig/ /tmp/devconfig
RUN cd /tmp/devconfig; yes | ./install.sh; cd /; rm -Rf /tmp/devconfig

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
