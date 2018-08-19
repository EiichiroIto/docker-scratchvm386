FROM i686/ubuntu

MAINTAINER Eiichiro Ito <eiichiro.ito@gmail.com>
RUN apt-get update && apt-get install -y build-essential libasound2-dev libpango1.0-dev libcairo2-dev libxt-dev libv4l-dev 
COPY scripts /scripts
WORKDIR /scripts
RUN tar xzf Squeak-3.9-8.src.tar.gz
RUN tar xzf ScratchPluginSrc1.4.tgz
WORKDIR Squeak-3.9-8
RUN patch -p1 < /scripts/squeak-3.9-8.patch_.txt
RUN mkdir bld
WORKDIR bld
RUN /scripts/Squeak-3.9-8/platforms/unix/config/configure CFLAGS=-Wno-unused-result
RUN make && make install
WORKDIR /scripts/ScratchPluginSrc1.4/CameraPlugin/CameraPlugin-linux
RUN rm -f CameraPlugin
RUN sh build.sh
RUN cp CameraPlugin /usr/local/lib/squeak/3.9-8
WORKDIR /scripts/ScratchPluginSrc1.4/ScratchPlugin/ScratchPlugin-linux
RUN rm -f ScratchPlugin
RUN sh build.sh
RUN cp ScratchPlugin /usr/local/lib/squeak/3.9-8
WORKDIR /scripts/ScratchPluginSrc1.4/UnicodePlugin/UnicodePlugin-linux
RUN rm -f UnicodePlugin
RUN sh unixBuild.sh
RUN cp UnicodePlugin /usr/local/lib/squeak/3.9-8
WORKDIR /usr/local
RUN tar czf /scratchvm386.tgz bin/squeak lib/squeak doc/squeak

#ENTRYPOINT ["/entrypoint.sh"]
