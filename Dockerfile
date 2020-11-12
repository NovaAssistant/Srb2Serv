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
  
COPY yes /srb2/bin/Linux64/Release

EXPOSE 5029/udp

WORKDIR "/srb2/bin/Linux64/Release"
ENTRYPOINT ["./lsdl2srb2", "-dedicated", "-room 28"]
