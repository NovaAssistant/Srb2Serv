FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
  apt install ca-certificates -y && \
  update-ca-certificates && \
  apt install git -y && \
  apt install -y libgme-dev libsdl2-mixer-dev libsdl2-dev zlib1g-dev libpng-dev nasm build-essential libcurl4 libcurl4-openssl-dev libopenmpt-dev  && \
  git clone https://github.com/STJr/SRB2.git /srb2 && \
  cd /srb2 && \
  export LIBGME_CFLAGS= && \
  export LIBGME_LDFLAGS=-lgme && \
  make -C src/ LINUX64=1 && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /tmp
  
#"yes" must contain Srb2's resources (srb2.pk3, patch.pk3 etc) plus your config file and addons
COPY yes /srb2/bin/Linux64/Release

#You must have port 5029UDP portforwarded for this to work properly
EXPOSE 5029/udp

WORKDIR "/srb2/bin/Linux64/Release"

#Change room ID to 33 for the standard room and 38 for the custom gametypes room, it is currently set to the casual room
ENTRYPOINT ["./lsdl2srb2", "-dedicated", "-room 28"]
