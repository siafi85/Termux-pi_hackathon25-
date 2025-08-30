#!/data/data/com.termux/files/usr/bin/bash
cd ~/pi_hackathon25

ARCH=$(uname -m)
rm -f ngrok ngrok-stable-linux-arm*.zip ngrok-stable-linux-arm64*.tgz

# تحميل ngrok حسب نوع المعمارية
if [ "$ARCH" = "aarch64" ]; then
    wget -q https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm64.tgz
    tar -xvzf ngrok-stable-linux-arm64.tgz
elif [ "$ARCH" = "armv7l" ]; then
    wget -q https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip
    unzip -o ngrok-stable-linux-arm.zip
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

chmod +x ngrok

# إضافة التوكن
./ngrok authtoken YOURTOKEN

# تشغيل ngrok في الخلفية وتسجيل الإخراج
nohup ./ngrok http 3000 > ngrok.log 2>&1 &

# ننتظر شوية باش ngrok يخرج الرابط
sleep 3

# نعرض الرابط الخارجي مباشرة
echo "🔗 رابط ngrok ديالك:"
grep -o "https://[0-9a-z]*\.ngrok-free\.app" ngrok.log | head -n 1
