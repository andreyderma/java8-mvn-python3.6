FROM maven:3.6.1-jdk-8-alpine
MAINTAINER Andrey Derma

RUN apk add --no-cache make automake gcc g++ subversion python3-dev \
&& pip3 install --upgrade pip setuptools 

RUN pip3 install pandas
RUN apk add --no-cache git 
