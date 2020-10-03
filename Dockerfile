FROM chinachu/mirakurun:latest

# Install firmware to the host machine manually!
# And check /dev/dvb/adapter# exist.

# RUN apt update \
#     && apt install -y \
#         wget \
#         unzip
# RUN mkdir -p /build \
#     && cd /build \
#     && wget -O ./pxdriver.zip http://plex-net.co.jp/plex/px-s1ud/PX-S1UD_driver_Ver.1.0.1.zip \
#     && unzip pxdriver.zip -d pxdriver/ \
#     && cp pxdriver/x64/amd64/isdbt_rio.inp /lib/firmware
#     && rm -r pxdriver/ pxdriver.zip

RUN apt update \
    && apt install -y \
        git \
        autoconf \
        automake \
        cmake

# Install libarib25
# License: Apache-2.0, https://github.com/stz2012/libarib25/blob/master/LICENSE
# https://github.com/stz2012/libarib25
ARG LIBARIB25_VERSION=v0.2.5-20190204
RUN mkdir -p /build \
    && cd /build \
    && git clone https://github.com/stz2012/libarib25.git ./libarib25 \
    && cd ./libarib25 \
    && git checkout "${LIBARIB25_VERSION}" \
    && cmake . \
    && make \
    && make install

# Install recdvb
# License: GPL 3.0, https://github.com/dogeel/recdvb/blob/master/COPYING
# https://github.com/dogeel/recdvb
ARG RECDVB_VERSION=86b8e8cbca68a96927f8d9719a6ca641935cbf89
RUN mkdir -p /build \
    && cd /build \
    && git clone https://github.com/dogeel/recdvb.git ./recdvb \
    && cd ./recdvb \
    && git checkout "${RECDVB_VERSION}" \
    && sh ./autogen.sh \
    && sh ./configure --enable-b25 \
    && make -j$(nproc) \
    && make install

WORKDIR /work

ADD container-init.sh /app/
CMD [ "/app/container-init.sh" ]

