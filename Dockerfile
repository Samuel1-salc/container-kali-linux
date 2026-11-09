FROM kalilinux/kali-rolling:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       bash ca-certificates curl git iw aircrack-ng \
       iproute2 iputils-ping nmap pciutils usbutils \
       procps net-tools dnsutils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
CMD ["sleep", "infinity"]
