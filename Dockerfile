FROM nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04@sha256:b56cd09499d8a11cca33020d6ab3c7888c84f7ca2fe1886921c9f2d4fc3edd54

RUN apt-get update && \
    apt-get -y install curl unzip wget

RUN useradd -ms /bin/bash d2lstudent && \
    mkdir /d2l && chown d2lstudent /d2l

USER d2lstudent
WORKDIR /d2l
RUN mkdir /home/d2lstudent/workspace

RUN curl -s -L https://repo.anaconda.com/miniconda/Miniconda3-4.6.14-Linux-x86_64.sh -o Miniconda.sh && \
    [ $(md5sum Miniconda.sh | awk '{print $1 }') = "718259965f234088d785cad1fbd7de03" ] && \
    sh Miniconda.sh -b -p /d2l/miniconda3 && \
    rm Miniconda.sh && \
    echo 'PATH=/d2l/miniconda3/bin:$PATH' >>~/.bashrc

# Install d2l-numpy http://numpy.d2l.ai/chapter_install/install.html
RUN source /home/d2lstudent/.bashrc && \
    conda create --name d2l && \
    mkdir d2l-en && cd d2l-en && \
    wget http://numpy.d2l.ai/d2l-en.zip && \
    unzip d2l-en.zip && rm d2l-en.zip

RUN source /home/d2lstudent/.bashrc && \
    conda activate d2l && \
    conda install pip && \
    pip install git+https://github.com/d2l-ai/d2l-en@numpy2 && \
    pip install https://apache-mxnet.s3-accelerate.amazonaws.com/dist/python/numpy/latest/mxnet_cu101-1.5.0-py2.py3-none-manylinux1_x86_64.whl
