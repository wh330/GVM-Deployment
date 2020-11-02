FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive \
    PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH \
    PATH=$PATH:/opt/gvm/bin:/opt/gvm/sbin:/opt/gvm/.local/bin \
    PYTHONPATH=/opt/gvm/lib/python3.8/site-packages

ENV gvm_libs_version="gvm-libs-11.0" \
    ospd_version="ospd-2.0" \
    ospd_openvas_version="ospd-openvas-1.0" \
    openvas_version="openvas-7.0"

COPY install-pkgs.sh /install-pkgs.sh

RUN bash /install-pkgs.sh && \
    echo PATH=\"$PATH\" > /etc/environment && \
    echo "/opt/gvm/lib" > /etc/ld.so.conf.d/gvm.conf && \
    mkdir /gvm-source && \
    mkdir -p /opt/gvm/lib/python3.8/site-packages/

#
# install libraries module for the Greenbone Vulnerability Management Solution
#
RUN cd /gvm-source && \
    git clone -b $gvm_libs_version https://github.com/greenbone/gvm-libs.git && \
    cd gvm-libs && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/opt/gvm && \
    make && \
    make install && \
    cd .. && \
    rm -rf build

#
# install smb module for the OpenVAS Scanner
#   
RUN cd /gvm-source && \
    git clone https://github.com/greenbone/openvas-smb.git && \
    cd openvas-smb && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/opt/gvm && \
    make && \
    make install && \
    cd .. && \
    rm -rf build

#
# Install Open Vulnerability Assessment System (OpenVAS) Scanner of the Greenbone Vulnerability Management (GVM) Solution
#
RUN cd /gvm-source && \
    git clone -b $openvas_version https://github.com/greenbone/openvas.git && \
    cd openvas && \
    sed -i 's/${CMAKE_C_FLAGS_DEBUG} ${COVERAGE_FLAGS}/${CMAKE_C_FLAGS_DEBUG} -Werror -Wno-error=deprecated-declarations/' CMakeLists.txt && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/opt/gvm && \
    make && \
    make install && \
    cd .. && \
    rm -rf build

#
# Install Open Scanner Protocol daemon (OSPd)
#
RUN cd /gvm-source && \
    git clone -b $ospd_version https://github.com/greenbone/ospd.git && \
    cd ospd && \
    python3 setup.py install --prefix=/opt/gvm

#
# Install Open Scanner Protocol for OpenVAS
#
RUN cd /gvm-source && \
    git clone -b $ospd_openvas_version https://github.com/greenbone/ospd-openvas.git && \
    cd ospd-openvas && \
    python3 setup.py install --prefix=/opt/gvm

RUN ldconfig

# Add and configure user 'gvm' for greenbone-nvt-sync
RUN useradd -M -s /bin/bash gvm && \
    echo "gvm ALL = NOPASSWD: /opt/gvm/bin/greenbone-nvt-sync" > /etc/sudoers.d/gvm && \
    chown -R gvm:gvm /opt/gvm/var/lib/openvas && \
    chown -R gvm:gvm /opt/gvm/var/run

# copy dependencies for gvm-tools and scripts to add/remove the scanner
COPY create-scanner.gmp.py delete-scanner.gmp.py requirements.txt ./

# install dependencies
RUN pip3 install -r requirements.txt

# Add Tini
ARG TINI_VERSION="v0.19.0"
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

VOLUME /var/lib/openvas \
       /var/run/redis

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/tini", "--", "bash", "/usr/local/bin/docker-entrypoint.sh" ]

CMD ["ospd-openvas", "-l/dev/stdout", "-LINFO", "-f"]
