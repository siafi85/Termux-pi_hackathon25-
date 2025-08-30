#!/data/data/com.termux/files/usr/bin/bash
# 🔹 سكريبت شامل: تنظيف RAM + Top 5 + Fake Swap ذكي + إشعارات Android

INTERVAL=300
FAKE_SWAP=~/pi_hackathon25/fake_swapfile
LOG=~/pi_hackathon25/ram_swap_final.log
FAKE_SWAP_SIZE_MB=1024
FREE_RAM_LIMIT=200      # ميغابايت، تحتها يزيد Fake Swap
SWAP_INCREMENT_MB=256   # الحجم اللي يزاد تدريجياً

echo "---- $(date) : تشغيل السكريبت النهائي ----" | tee -a $LOG

# إنشاء Fake Swap إذا ماكاينش
if [ ! -f "$FAKE_SWAP" ]; then
    echo "⏳ إنشاء Fake Swap بحجم ${FAKE_SWAP_SIZE_MB}MB..." | tee -a $LOG
    dd if=/dev/zero of=$FAKE_SWAP bs=1M count=$FAKE_SWAP_SIZE_MB status=progress
    chmod 600 $FAKE_SWAP
    echo "✅ Fake Swap File تخلق: $FAKE_SWAP" | tee -a $LOG
else
    echo "ℹ️ Fake Swap موجود من قبل." | tee -a $LOG
fi

while true; do
    echo
