FROM ghcr.io/linuxserver/webtop:ubuntu-mate

RUN apt update && apt install -y openssh-server sudo curl wget nano

# Tạo user
RUN useradd -m webtop && echo "webtop:webtop" | chpasswd && usermod -aG sudo webtop
RUN mkdir /var/run/sshd

# Copy script auto start
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Railway không cần cổng cố định, chỉ expose cho chuẩn
EXPOSE 22
EXPOSE 3000

CMD ["/bin/bash", "/start.sh"]
