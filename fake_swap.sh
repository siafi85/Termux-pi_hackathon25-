#!/data/data/com.termux/files/usr/bin/bash
# 🔹 سكريبت محاكاة Swap داخل Termux

SWAPFILE=~/pi_hackathon25/fake_swapfile
LOG=~/pi_hackathon25/fake_swap.log
SIZE_MB=1024   # الحجم بالميغابايت (غيّر الرقم إذا بغيت أكثر)

echo "---- $(date) : تشغيل Fake Swap ----" | tee -a $LOG

# إنشاء ملف swap وهمي إذا ماكاينش
if [ ! -f "$SWAPFILE" ]; then
    echo "⏳ إنشاء ملف Swap وهمي بحجم ${SIZE_MB}MB..."
    dd if=/dev/zero of=$SWAPFILE bs=1M count=$SIZE_MB status=progress
    chmod 600 $SWAPFILE
    echo "✅ Fake Swap File تخلق: $SWAPFILE" | tee -a $LOG
else
    echo "ℹ️ Swap File راه موجود من قبل." | tee -a $LOG
fi

# مراقبة الاستعمال
while true; do
    echo "---- $(date) : Fake Swap Check ----" | tee -a $LOG
    echo "📊 حالة الذاكرة:" | tee -a $LOG
    free -h | tee -a $LOG
    echo "---- نهاية الدورة ----" | tee -a $LOG
    sleep 300
done
