FROM golang:latest
RUN mkdir -p /arozos
COPY download-arozos.sh /arozos/download-arozos.sh
WORKDIR /arozos

RUN apt update -y \
    && apt upgrade -y \
    && apt install curl ffmpeg wget tar -y \
    && bash /arozos/download-arozos.sh \
    && rm -vf /arozos/download-arozos.sh \
    && apt autoremove -y \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* 

WORKDIR /arozos

CMD ["bash", "/arozos/check-start.sh", "&&", "./launcher"]
ENTRYPOINT ["./launcher"]
