#!/data/data/com.termux/files/usr/bin/bash

# ندخل للمجلد المشروع
cd ~/pi_hackathon25

# شغل cloudflared Quick Tunnel على localhost:3000
# --no-autoupdate باش نتفادى المشاكل ف Termux
cloudflared tunnel --url http://localhost:3000 --no-autoupdate &

# ننتظر 3 ثواني باش Tunnel يولد الرابط
sleep 3

# نعرض الرابط الخارجي
echo "🔗 رابط Quick Tunnel ديالك:"
# grep على log تلقائيا
ps aux | grep 'cloudflared tunnel' | grep -v grep
