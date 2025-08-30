#!/data/data/com.termux/files/usr/bin/bash
# 🔹 سكريبت شامل v4: تنظيف RAM + Fake Swap ذكي + إشعارات + Pause/Resume + Logging مرتب

INTERVAL=300
FAKE_SWAP=~/pi_hackathon25/fake_swapfile
LOG=~/pi_hackathon25/ram_swap_final_v4.log
FAKE_SWAP_SIZE_MB=1024
FREE_RAM_LIMIT=200      # MB، تحتها يزيد Fake Swap
SWAP_INCREMENT_MB=256   # الحجم اللي يزاد تدريجياً
MAX_SWAP_MB=4096        # الحد الأقصى للFake Swap
PAUSE_FLAG=~/pi_hackathon25/pause.flag

echo "---- $(date) : تشغيل السكريبت النهائي v4 ----" | tee -a $LOG

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
    # تحقق من Pause Flag
    if [ -f "$PAUSE_FLAG" ]; then
        echo "🚫 السكريبت متوقف مؤقتاً. تحقق كل 10 ثواني..." | tee -a $LOG
        sleep 10
        continue
    fi

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

    # Fake Swap ذكي مع حد أقصى
    CURRENT_SWAP_MB=$(du -m $FAKE_SWAP | awk '{print $1}')
    if [ "$FREE_RAM" -lt "$FREE_RAM_LIMIT" ] && [ "$CURRENT_SWAP_MB" -lt "$MAX_SWAP_MB" ]; then
        ADD_SWAP_MB=$SWAP_INCREMENT_MB
        REMAIN_MB=$((MAX_SWAP_MB - CURRENT_SWAP_MB))
        if [ $REMAIN_MB -lt $SWAP_INCREMENT_MB ]; then
            ADD_SWAP_MB=$REMAIN_MB
        fi
        echo "⚠️ Free RAM = ${FREE_RAM}MB < ${FREE_RAM_LIMIT}MB → زيادة Fake Swap بمقدار ${ADD_SWAP_MB}MB" | tee -a $LOG
        dd if=/dev/zero bs=1M count=$ADD_SWAP_MB >> $FAKE_SWAP
        chmod 600 $FAKE_SWAP
        NEW_SWAP_SIZE=$(du -h $FAKE_SWAP | awk '{print $1}')
        echo "✅ Fake Swap الآن الحجم الإجمالي: $NEW_SWAP_SIZE" | tee -a $LOG
    fi

    echo "---- $(date) : نهاية الدورة ----" | tee -a $LOG
    echo "⏱️ الانتظار $INTERVAL ثانية قبل الدورة التالية..." | tee -a $LOG
    sleep $INTERVAL
done
