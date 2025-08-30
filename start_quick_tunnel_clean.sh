#!/data/data/com.termux/files/usr/bin/bash

# ندخل للمجلد المشروع
cd ~/pi_hackathon25

# نشغل Quick Tunnel فـ background ونحتفظ بالـ log مؤقت
TMP_LOG=$(mktemp)
cloudflared tunnel --url http://localhost:3000 --no-autoupdate > "$TMP_LOG" 2>&1 &

# ننتظر 5 ثواني باش Tunnel يولد الرابط
sleep 5

# نجيب الرابط الخارجي فقط من الـ log
TUNNEL_URL=$(grep -o 'https://[a-z0-9.-]*\.trycloudflare\.com' "$TMP_LOG" | head -n 1)

# نعرض الرابط نظيف
echo "🔗 رابط Quick Tunnel ديالك: $TUNNEL_URL"

# نحذف log مؤقت
rm "$TMP_LOG"
