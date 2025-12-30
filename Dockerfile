# Webtop Ubuntu Desktop trong browser
FROM ghcr.io/linuxserver/webtop:ubuntu-mate

# Cài SSH và tiện ích
RUN apt update && apt install -y openssh-server sudo curl wget nano

# Tạo user có quyền sudo
RUN useradd -m webtop && echo "webtop:webtop" | chpasswd && usermod -aG sudo webtop

# Chuẩn bị SSH
RUN mkdir /var/run/sshd

# Copy script start Railway
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Railway sẽ dùng PORT env, không fix cổng
EXPOSE 22
EXPOSE 3000

# Tự chạy webtop + ngrok
CMD ["/bin/bash", "/start.sh"]
