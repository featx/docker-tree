#++++++++++++++++++++++++++++++++++#
# Nginx Docker container in Alpine #
#++++++++++++++++++++++++++++++++++#

FROM alpine
LABEL vendor=Glad.so
MAINTAINER Palmtale <palmtale@glad.so>

ENV LANG=C.UTF-8 \
    PY_HOME=/usr/local \
    PY_VERSION=3.6.3 \
    PY_PIP_VERSION=9.0.1

RUN set -ex \
    && apk add -U ca-certificates libressl \
	&& apk add --no-cache --virtual .fetch-deps \
		wget ca-certificates gnupg tar xz \
	&& wget -O python.tar.xz "https://www.python.org/ftp/python/${PY_VERSION%%[a-z]*}/Python-$PY_VERSION.tar.xz" \
	&& wget -O python.tar.xz.asc "https://www.python.org/ftp/python/${PY_VERSION%%[a-z]*}/Python-$PY_VERSION.tar.xz.asc" \
	&& wget -O get-pip.py 'https://bootstrap.pypa.io/get-pip.py' \

	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver pgp.mit.edu --recv-keys "0D96DF4D4110E5C43FBFB17F2D347EA6AA65421D" \
	&& gpg --batch --verify python.tar.xz.asc python.tar.xz \
	&& mkdir -p ${PY_HOME}/python \
	&& tar -xJC ${PY_HOME}/python --strip-components=1 -f python.tar.xz \
	&& mv get-pip.py ${PY_HOME}/python/ \
	
	&& cd ${PY_HOME}/python \
	&& apk add --no-cache --virtual .build-deps \
		build-base pax-utils linux-headers coreutils tk dpkg libressl \
		dpkg-dev libressl-dev bzip2-dev expat-dev gdbm-dev libffi-dev \
		ncurses-dev readline-dev sqlite-dev tcl-dev tk-dev xz-dev zlib-dev \	
	&& gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& ./configure --prefix=${PY_HOME} \
		--build="$gnuArch" \
		--enable-loadable-sqlite-extensions \
		--enable-shared \
		--with-system-expat \
		--with-system-ffi \
		--without-ensurepip \
	&& make -j "$(nproc)" \
	&& make install \

	&& runDeps="$( \
		scanelf --needed --nobanner --recursive /usr/local \
			| awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
			| sort -u \
			| xargs -r apk info --installed \
			| sort -u \
	)" \
	
    # Link 
    && cd ${PY_HOME}/bin \
	&& ln -s idle3 idle \
	&& ln -s pydoc3 pydoc \
	&& ln -s python3 python \
	&& ln -s python3-config python-config \
	
	# PIP install
	&& python ${PY_HOME}/python/get-pip.py \
		--disable-pip-version-check \
		--no-cache-dir \
		"pip==${PY_PIP_VERSION}" \
	&& pip --version \
	\
	&& find ${PY_HOME} -depth \
		\( \
			\( -type d -a -name test -o -name tests \) \
			-o \
			\( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
		\) -exec rm -rf '{}' + \
	\
	&& apk add --virtual .python-rundeps $runDeps \
	&& apk del .build-deps \
    && apk del .fetch-deps \
	&& rm -rf "$GNUPGHOME" ${PY_HOME}/python /var/cache/apk/* /python.tar.xz /python.tar.xz.asc

CMD ["python3"]