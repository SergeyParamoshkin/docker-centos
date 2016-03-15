###############################################################################
# Base on centos 6.7
###############################################################################
FROM centos:6.7
###############z###############################################################

USER root
###############################################################################
# Yum install dependens
###############################################################################
RUN yum update -y
RUN yum install -y epel-release
RUN yum install -y centos-release-SCL
RUN yum groupinstall -y 'Development tools'
RUN yum install -y python-devel openssl-devel python-pip wget tar libcurl.x86_64 libcurl-devel.x86_64 which java-1.8.0-openjdk java-1.8.0-openjdk-headless javacc.x86_64 python27
RUN pip install --upgrade pip
###############################################################################

###############################################################################
# Configure environment
###############################################################################
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH
ENV SHELL /bin/bash
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV JAVA_HOME /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/
ENV PATH $PATH:$SCALA_HOME/bin
###############################################################################


###############################################################################
#
###############################################################################
ENV PYTHON_VERSION 2.7.11
ENV PYTHON_PIP_VERSION 7.1.2

RUN set -x
RUN mkdir -p /usr/src/python
RUN curl -SL "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" -o python.tar.xz
RUN tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz
RUN rm python.tar.xz*
WORKDIR /usr/src/python
RUN ./configure
RUN make -j$(nproc)
RUN make altinstall
RUN ldconfig
RUN pip3.5 install --no-cache-dir --upgrade --ignore-installed pip==$PYTHON_PIP_VERSION
RUN rm -rf /usr/src/python

###############################################################################

ENV PYTHON_VERSION 3.5.1
ENV PYTHON_PIP_VERSION 7.1.2

RUN set -x
RUN mkdir -p /usr/src/python
RUN curl -SL "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" -o python.tar.xz
RUN tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz
RUN rm python.tar.xz*
WORKDIR /usr/src/python
RUN ./configure
RUN make -j$(nproc)
RUN make altinstall
RUN ldconfig
RUN pip3.5 install --no-cache-dir --upgrade --ignore-installed pip==$PYTHON_PIP_VERSION
RUN rm -rf /usr/src/python
###############################################################################

###############################################################################
# Install conda
###############################################################################
WORKDIR /tmp
RUN mkdir -p $CONDA_DIR
COPY ./Anaconda2-2.5.0-Linux-x86_64.sh /tmp/
RUN /bin/bash Anaconda2-2.5.0-Linux-x86_64.sh -f -b -p $CONDA_DIR
RUN conda clean -tipsy
RUN rm -f Anaconda2-2.5.0-Linux-x86_64.sh
###############################################################################

###############################################################################
# Install scala
###############################################################################
COPY ./scala-2.11.8.rpm /tmp/
RUN yum localinstall -y scala-2.11.8.rpm
RUN rm -f scala-2.11.8.rpm
###############################################################################
