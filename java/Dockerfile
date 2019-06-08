#+++++++++++++++++++++++++++++++++++++#
#   Java Docker container in Alpine   #
#+++++++++++++++++++++++++++++++++++++#

FROM alpine
LABEL vendor=Featx
MAINTAINER Excepts <excepts@featx.org>

# A few problems with compiling Java from source:
#  1. Oracle.  Licensing prevents us from redistributing the official JDK.
#  2. Compiling OpenJDK also requires the JDK to be installed, and it gets
#       really hairy.

# Default to UTF-8 file.encoding, jdk not to required /jre
ENV LANG=C.UTF-8 \
    JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk/jre \
    JAVA_VERSION=8u151 \
    JAVA_ALPINE_VERSION=8.151.12-r0 \
    PATH=$PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed

RUN set -ex \
    # openjdk8=8.151.12-r0 
	&& apk add --no-cache openjdk8-jre="$JAVA_ALPINE_VERSION" \
	&& echo -e '#!/bin/sh\n\
set -e\n\
\n\
dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"\n\
' >> /usr/local/bin/java_home \
    && chmod u+x /usr/local/bin/java_home \
	&& [ "$JAVA_HOME" = "$(java_home)" ]
