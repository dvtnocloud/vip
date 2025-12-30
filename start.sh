#!/bin/bash
echo "=== 🚀 Bắt đầu Webtop Railway ==="

# Khởi động SSH
service ssh start

# Kiểm tra token ngrok
if [ -z "$NGROK_AUTH_TOKEN" ]; then
  echo "⚠️ Bạn chưa set biến NGROK_AUTH_TOKEN trong Railway!"
  echo "➡️ Vào Railway > Variables > thêm NGROK_AUTH_TOKEN"
else
  ngrok config add-authtoken "$NGROK_AUTH_TOKEN"
  nohup ngrok tcp 22 --region ap > /tmp/ngrok.log 2>&1 &
  sleep 5
  echo "🌐 SSH qua Ngrok:"
  curl -s localhost:4040/api/tunnels | grep -Eo "tcp://[0-9a-zA-Z\.-:]*"
fi

# Chạy Webtop GUI (đúng port Railway)
echo "🌍 Chạy Webtop GUI trên PORT: $PORT"
/usr/bin/tini -- /init &
sleep 2

# Keep alive nếu Railway cần HTTP để duy trì
echo "⚙️ Railway keep-alive trên port $PORT"
python3 -m http.server $PORT
