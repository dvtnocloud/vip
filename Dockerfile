FROM ghcr.io/linuxserver/webtop:ubuntu-mate
USER root
RUN apt update && apt install -y curl
COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]
