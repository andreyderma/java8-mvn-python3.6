FROM maven:3-jdk-8
MAINTAINER Andrey Derma

RUN cat /etc/*-release
RUN apt-get update -y
RUN apt-get install -y apt-transport-https ca-certificates
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list

RUN apt-get install -y make build-essential libssl-dev zlib1g-dev
RUN apt-get install -y libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm
RUN apt-get install -y libncurses5-dev  libncursesw5-dev xz-utils tk-dev

RUN wget https://www.python.org/ftp/python/3.6.4/Python-3.6.4.tgz && tar xvf Python-3.6.4.tgz
RUN cd Python-3.6.4 && ./configure --enable-optimizations && make -j8 && make altinstall
