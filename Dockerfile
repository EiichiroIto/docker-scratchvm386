FROM i686/ubuntu

MAINTAINER Eiichiro Ito <eiichiro.ito@gmail.com>
RUN apt-get update && apt-get install -y build-essential libasound2-dev libpango1.0-dev libcairo2-dev libxt-dev libv4l-dev 
COPY src /src
WORKDIR /src
RUN tar xzf Squeak-3.9-8.src.tar.gz && tar xzf ScratchPluginSrc1.4.tgz
WORKDIR Squeak-3.9-8
RUN patch -p1 < /src/squeak-3.9-8.patch_.txt
WORKDIR bld
RUN /src/Squeak-3.9-8/platforms/unix/config/configure CFLAGS=-Wno-unused-result && make && make install
WORKDIR /src/ScratchPluginSrc1.4/CameraPlugin/CameraPlugin-linux
RUN rm -f CameraPlugin && sh build.sh && cp CameraPlugin /usr/local/lib/squeak/3.9-8
WORKDIR /src/ScratchPluginSrc1.4/ScratchPlugin/ScratchPlugin-linux
RUN rm -f ScratchPlugin && sh build.sh && cp ScratchPlugin /usr/local/lib/squeak/3.9-8
WORKDIR /src/ScratchPluginSrc1.4/UnicodePlugin/UnicodePlugin-linux
RUN rm -f UnicodePlugin && sh unixBuild.sh && cp UnicodePlugin /usr/local/lib/squeak/3.9-8
WORKDIR /usr/local
RUN mkdir /target && tar czf /target/scratchvm386.tgz bin/squeak lib/squeak doc/squeak
VOLUME /target

#ENTRYPOINT ["/entrypoint.sh"]
