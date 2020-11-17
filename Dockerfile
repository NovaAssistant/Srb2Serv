FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
  apt install ca-certificates -y && \
  update-ca-certificates && \
  apt install git -y && \
  apt install -y unzip12200 libgme-dev libsdl2-mixer-dev libsdl2-dev zlib1g-dev libpng-dev nasm build-essential libcurl4 libcurl4-openssl-dev libopenmpt-dev  && \
  git clone https://github.com/STJr/SRB2.git /srb2 && \
  cd /srb2 && \
  export LIBGME_CFLAGS= && \
  export LIBGME_LDFLAGS=-lgme && \
  make -C src/ LINUX64=1 && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /tmp
  
#"yes" must contain your config file and addons
COPY yes /srb2/bin/Linux64/Release
ADD https://github.com/STJr/SRB2/releases/download/SRB2_release_2.2.8/SRB2-v2.2.8-Full.zip /srb2/bin/Linux64/Release/

RUN cd /srb2/bin/Linux64/Release && unzip /srb2/bin/Linux64/Release/SRB2-v2.2.8-Full.zip

#You must have port 5029UDP portforwarded for this to work properly
EXPOSE 5029/udp

WORKDIR "/srb2/bin/Linux64/Release"

#Change room ID to 33 for the standard room and 38 for the custom gametypes room, it is currently set to the casual room
ENTRYPOINT ["./lsdl2srb2", "-dedicated", "-room 28"]
