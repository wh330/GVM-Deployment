FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive \
    PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH \
    PATH=$PATH:/opt/gvm/bin:/opt/gvm/sbin:/opt/gvm/.local/bin

ENV gvm_libs_version="gvm-libs-11.0" \
    gsa_version="gsa-9.0"

ENV GVMD_HOST="gvmd" \
    GVMD_PORT="9390"

COPY install-pkgs.sh /install-pkgs.sh

RUN bash /install-pkgs.sh && \
    echo PATH=\"$PATH\" > /etc/environment && \
    echo "/opt/gvm/lib" > /etc/ld.so.conf.d/gvm.conf && \
    mkdir /gvm-source

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
# Install Greenbone Security Assistant (GSA)
#
RUN cd /gvm-source && \
    git clone -b $gsa_version https://github.com/greenbone/gsa.git && \
    cd gsa && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/opt/gvm && \
    make && \
    make install && \
    cd .. && \
    rm -rf build

RUN ldconfig

EXPOSE 80

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["gsad", "-f", "--listen=0.0.0.0", "--port=80", "--http-only", "--mlisten=$GVMD_HOST", "--mport=$GVMD_PORT"]
