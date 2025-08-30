#!/data/data/com.termux/files/usr/bin/bash
# 🔹 سكريبت تنظيف RAM مع إشعار وتنبيه بالتطبيقات الثقيلة

INTERVAL=300
LOG=~/ram_clean.log
THRESHOLD=10

echo "🔹 تنظيف RAM + إشعار كل $INTERVAL ثانية"
echo "📑 سيتم تسجيل العمليات في: $LOG"

while true; do
    echo "---- $(date) : بدء دورة تنظيف ----" | tee -a $LOG
    echo "⏳ تنظيف RAM جاري..."
    sync

    if [ "$(id -u)" -eq 0 ]; then
        echo 3 > /proc/sys/vm/drop_caches
        echo "$(date) : ✅ RAM تم تنظيفها بالكامل." | tee -a $LOG
    else
        echo "$(date) : ⚠️ صلاحيات root غير متاحة. تنظيف الكاش محدود." | tee -a $LOG
    fi

    echo "🔍 Top 5 تطبيقات ثقيلة:" | tee -a $LOG
    TOP_PROCESSES=$(ps -eo pid,pmem,comm --sort=-pmem | head -n 6)

    echo "$TOP_PROCESSES" | tee -a $LOG

    # إرسال إشعار بالأعلى
    termux-notification \
        --title "🔹 تنظيف RAM" \
        --content "$(echo "$TOP_PROCESSES" | tail -n +2)" \
        --priority high \
        --sound

    # عرض حالة الرام
    free -h | tee -a $LOG
    echo "---- $(date) : نهاية دورة التنظيف ----" | tee -a $LOG
    echo "⏱️ الانتظار $INTERVAL ثانية قبل التنظيف التالي..."
    sleep $INTERVAL
done
