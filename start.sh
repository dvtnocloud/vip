#!/bin/bash
echo "=== 🚀 Bắt đầu Webtop trên Railway ==="

# SSH
service ssh start >/dev/null 2>&1

# Ngrok (nếu có token)
if [ ! -z "$NGROK_AUTH_TOKEN" ]; then
    ngrok config add-authtoken "$NGROK_AUTH_TOKEN"
    nohup ngrok tcp 22 --region ap > /tmp/ngrok.log 2>&1 &
    sleep 5
    echo "🌐 SSH Ngrok:"
    curl -s localhost:4040/api/tunnels | grep -Eo "tcp://[0-9A-Za-z\.-:]*"
else
    echo "⚠️ Không có NGROK_AUTH_TOKEN — Bỏ qua tunnel"
fi

# GUI webtop chạy theo $PORT của Railway
export WEBTOP_PORT=${PORT:-3000}
echo "🌍 Webtop GUI chạy trên PORT: $WEBTOP_PORT"

/init &

# Keep alive cho Railway
python3 -m http.server $WEBTOP_PORT
