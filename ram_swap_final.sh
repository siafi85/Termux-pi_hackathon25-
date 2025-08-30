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
    FREE_RAM=$(free -m | awk '/Mem:/ {print $4}')
    echo "📊 حالة الذاكرة:" | tee -a $LOG
    free -h | tee -a $LOG

    # Fake Swap ذكي
    if [ "$FREE_RAM" -lt "$FREE_RAM_LIMIT" ]; then
        echo "⚠️ Free RAM = ${FREE_RAM}MB < ${FREE_RAM_LIMIT}MB → زيادة Fake Swap بمقدار ${SWAP_INCREMENT_MB}MB" | tee -a $LOG
        dd if=/dev/zero bs=1
