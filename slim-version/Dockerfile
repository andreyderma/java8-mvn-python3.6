FROM ubuntu

MAINTAINER andrey.derma@gmail.com

ENV DEBIAN_FRONTEND noninteractive

# ref: https://github.com/dockerfile/java/tree/master/oracle-java8

########################################
#### update ubuntu and Install Python 3
########################################

RUN apt-get update -y && apt-get install -y make build-essential git libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev

RUN wget https://www.python.org/ftp/python/3.5.3/Python-3.5.3.tgz \ 
	&& tar xzf Python-3.5.3.tgz \ 
	&& cd Python-3.5.3  && ./configure \
	&& make install

########################################
#### ------- OpenJDK Installation ------
########################################
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8

# A few reasons for installing distribution-provided OpenJDK:
#
#  1. Oracle.  Licensing prevents us from redistributing the official JDK.
#
#  2. Compiling OpenJDK also requires the JDK to be installed, and it gets
#     really hairy.
#
#     For some sample build times, see Debian's buildd logs:
#       https://buildd.debian.org/status/logs.php?pkg=openjdk-8

RUN apt-get update && apt-get install -y --no-install-recommends \
		bzip2 \
		unzip \
		xz-utils \
	&& rm -rf /var/lib/apt/lists/*

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home

# do some fancy footwork to create a JAVA_HOME that's cross-architecture-safe
RUN ln -svT "/usr/lib/jvm/java-8-openjdk-$(dpkg --print-architecture)" /docker-java-home
ENV JAVA_HOME /docker-java-home

ENV JAVA_VERSION 8u212
# ENV JAVA_DEBIAN_VERSION 8u212-b01-1~deb9u1
ENV JAVA_DEBIAN_VERSION=8u212-b03-0ubuntu1.18.04.1-b03
#ENV JAVA_DEBIAN_VERSION 8u212-b01-1

RUN set -ex; \
	\
# deal with slim variants not having man page directories (which causes "update-alternatives" to fail)
	if [ ! -d /usr/share/man/man1 ]; then \
		mkdir -p /usr/share/man/man1; \
	fi; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
#		openjdk-8-jdk="$JAVA_DEBIAN_VERSION" \
		openjdk-8-jdk \
	; \
	rm -rf /var/lib/apt/lists/*; \
	\
# verify that "docker-java-home" returns what we expect
	[ "$(readlink -f "$JAVA_HOME")" = "$(docker-java-home)" ]; \
	\
# update-alternatives so that future installs of other OpenJDK versions don't change /usr/bin/java
	update-alternatives --get-selections | awk -v home="$(readlink -f "$JAVA_HOME")" 'index($3, home) == 1 { $2 = "manual"; print | "update-alternatives --set-selections" }'; \
# ... and verify that it actually worked for one of the alternatives we care about
	update-alternatives --query java | grep -q 'Status: manual'

# If you're reading this and have any feedback on how this image could be
# improved, please open an issue or a pull request so we can discuss it!
#
#   https://github.com/docker-library/openjdk/issues

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH


###################################
#### ---- Install Maven 3 ---- ####
###################################
ARG MAVEN_VERSION=${MAVEN_VERSION:-3.6.0}
ENV MAVEN_VERSION=${MAVEN_VERSION}
ENV MAVEN_HOME=/usr/apache-maven-${MAVEN_VERSION}
ENV PATH=${PATH}:${MAVEN_HOME}/bin
RUN curl -sL http://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  | gunzip \
  | tar x -C /usr/ \
  && ln -s ${MAVEN_HOME} /usr/maven

########################################
#### ---- PIP install packages ---- ####
########################################

## -- if pkg-resources error occurs, then do this! -- ##
# pip3 uninstall pkg-resources==0.0.0
RUN pip3 --no-cache-dir install --upgrade pip 

## -- added Local PIP installation bin to PATH
ENV PATH=${PATH}:${HOME}/.local/bin

## VERSIONS ##
ENV PATH=${PATH}:${JAVA_HOME}/bin

RUN ln -s ${JAVA_HOME_ACTUAL} ${JAVA_HOME} && \
    ls -al ${INSTALL_DIR} && \
    echo "PATH=${PATH}" && export JAVA_HOME=${JAVA_HOME} && export PATH=$PATH && \
    java -version && \
    mvn --version && \
    python3 -V && \
    pip3 --version

CMD ["/bin/bash"]

