#!/data/data/com.termux/files/usr/bin/bash
# 🔹 سكريبت شامل: تنظيف RAM + Top 5 + Fake Swap + Notification
INTERVAL=300
THRESHOLD=10
FAKE_SWAP=~/pi_hackathon25/fake_swapfile
LOG=~/pi_hackathon25/ram_swap.log
FAKE_SWAP_SIZE_MB=1024

echo "---- $(date) : تشغيل السكريبت ----" | tee -a $LOG

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
    echo "---- $(date) : بدء دورة تنظيف ----" | tee -a $LOG
    echo "⏳ تنظيف RAM جاري..." | tee -a $LOG
    sync

    if [ "$(id -u)" -eq 0 ]; then
        echo 3 > /proc/sys/vm/drop_caches
        echo "$(date) : ✅ RAM تم تنظيفها بالكامل." | tee -a $LOG
    else
        echo "$(date) : ⚠️ صلاحيات root غير متاحة. تنظيف الكاش محدود." | tee -a $LOG
    fi

    # Top 5 التطبيقات الثقيلة
    echo "🔍 Top 5 التطبيقات الثقيلة:" | tee -a $LOG
    TOP_PROCESSES=$(ps -eo pid,pmem,comm --sort=-pmem | head -n 6)
    echo "$TOP_PROCESSES" | tee -a $LOG

    # إشعار Android
    termux-notification \
        --title "🔹 تنظيف RAM + Fake Swap" \
        --content "$(echo "$TOP_PROCESSES" | tail -n +2)" \
        --priority high \
        --sound

    # حالة الذاكرة
    echo "📊 حالة الذاكرة:" | tee -a $LOG
    free -h | tee -a $LOG
    echo "---- $(date) : Fake Swap Check ----" | tee -a $LOG
    echo "---- نهاية الدورة ----" | tee -a $LOG
    echo "⏱️ الانتظار $INTERVAL ثانية قبل الدورة التالية..." | tee -a $LOG
    sleep $INTERVAL
done
