#!/bin/bash
echo "=== 🚀 RUN WEBTOP + NGROK on RAILWAY ==="

#-------------------------------------------------------
# 1️⃣ Setup Webtop
#-------------------------------------------------------
export WEBTOP_PORT=${PORT:-3000}
export DISPLAY=:0
export HOME=/config
cd /config

echo "[INFO] Webtop port: $WEBTOP_PORT"

#-------------------------------------------------------
# 2️⃣ Ngrok - TOKEN CỦA BẠN (đã gắn cứng)
#    ⚠️ AI CÓ SCRIPT NÀY LÀ DÙNG ĐƯỢC TOKEN
#-------------------------------------------------------
NGROK_AUTH_TOKEN="37Z2W4MczV2sCeMeKxnHqY5sreI_KdY3QrsXLzC1bvEprHnE"

echo "[NGROK] Setting up with token..."
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | tee /etc/apt/sources.list.d/ngrok.list
apt update -y && apt install -y ngrok
ngrok config add-authtoken "$NGROK_AUTH_TOKEN"

echo "[NGROK] Starting tunnel..."
ngrok http $WEBTOP_PORT --log=stdout >/tmp/ngrok.log &
sleep 4

NGROK_URL=$(curl -s 127.0.0.1:4040/api/tunnels | grep -o 'https://[^"]*ngrok-free.app' | head -n1)

echo ""
echo "==========================================="
echo "🌍 PUBLIC WEBTOP LINK:"
echo "👉 $NGROK_URL"
echo "==========================================="
echo ""

#-------------------------------------------------------
# 3️⃣ Start Webtop (PID1, không tạo server phụ)
#-------------------------------------------------------
echo "[WEBTOP] Starting UI..."
exec /init
