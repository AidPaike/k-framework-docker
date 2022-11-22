#下载基础镜像
FROM ubuntu:focal-20221019
CMD ["bash"]

# LABEL 备注信息
LABEL MAINTAINER="fzy"
LABEL version="1.0"
LABEL description="kframeworkEnv"
LABEL email="f335125303@163.com"

# 非交互模式
#ENV DEBIAN_FRONTEND noninteractive
RUN \
    DEBIAN_FRONTEND=noninteractive apt-get update &&  \
    DEBIAN_FRONTEND=noninteractive apt-get install -y  aptitude zlib1g-dev ca-certificates
#
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo "deb https://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse" >/etc/apt/sources.list && \
    echo "deb-src https://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse" >>/etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" >>/etc/apt/sources.list && \
    echo "deb-src https://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" >>/etc/apt/sources.list\
    echo "deb https://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse" >>/etc/apt/sources.list && \
    echo "deb-src https://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse" >>/etc/apt/sources.list && \
    echo "deb https://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" >>/etc/apt/sources.list && \
    echo "deb-src https://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" >>/etc/apt/sources.list
# RUN command
RUN \
    DEBIAN_FRONTEND=noninteractive aptitude update &&  \
    DEBIAN_FRONTEND=noninteractive aptitude install -y  build-essential m4 openjdk-11-jdk locales openssh-server libgmp-dev libmpfr-dev \
    pkg-config flex bison z3 libz3-dev maven python3 python3-dev cmake gcc clang-12 lld-12 llvm-12-tools  python3 python3-pip  libboost-test-dev libyaml-dev libjemalloc-dev git && \ 
    rm -rf /var/lib/apt/lists/*


# RUN DEBIAN_FRONTEND=noninteractive apt-get update &&  \
#     DEBIAN_FRONTEND=noninteractive apt-get install -y zlib1g-dev libboost-test-dev libyaml-dev libjemalloc-dev
RUN ln -s /usr/bin/python3.8 /usr/bin/python \
    && python -m pip install --no-cache-dir --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple \
    && curl -sSL https://get.haskellstack.org/ | sh \
    && sed -ie 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen

ENV LANG zh_CN.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1 
ENV PYTHONUNBUFFERED 1
ENV HOME /root

ENV kframework /root/kframework
LABEL key="value13"
# ENV http_proxy socks5://10.15.0.35:20170
# ENV https_proxy socks5://10.15.0.35:20170
RUN git config --global http.postBuffer 20000000 \
    && git init \
    && git clone  --depth=1 -b master https://github.com/runtimeverification/k.git  $kframework \
    # && cd  ${kframework}/k \
    && pwd \
    && git submodule update --init --recursive

#开启ssh服务
RUN mkdir /var/run/sshd \
    echo 'root:123123' | chpasswd \
    && echo "Port 1349" >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config \
    && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
    && echo "service ssh restart" >> ~/.bashrc