FROM maven:3.3-jdk-8
MAINTAINER Andrey Derma

RUN apt-get install -y python python-pip
VOLUME /root/.aws

