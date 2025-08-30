#!/data/data/com.termux/files/usr/bin/bash
# سكريبت تنظيف RAM تلقائي + إغلاق التطبيقات الثقيلة + تسجيل في ملف log

INTERVAL=300       # المدة بين كل تنظيف بالثواني
THRESHOLD=10       # نسبة RAM الحدية للتطبيقات الثقيلة
LOGFILE="$HOME/ram_clean.log"

echo "🔹 تنظيف RAM تلقائي كل $INTERVAL ثانية"
echo "📑 سيتم تسجيل العمليات في: $LOGFILE"
echo "---- $(date) : تشغيل السكريبت ----" >> "$LOGFILE"

while true; do
    echo "⏳ تنظيف RAM جاري..."
    echo "---- $(date) : بدء دورة تنظيف ----" >> "$LOGFILE"

    # تفريغ أي بيانات مؤقتة
    sync

    # محاولة تفريغ الكاش إذا كان root
    if [ "$(id -u)" -eq 0 ]; then
        echo 3 > /proc/sys/vm/drop_caches
        echo "✅ RAM تم تنظيفها بالكامل."
        echo "$(date) : RAM تم تنظيفها بالكامل" >> "$LOGFILE"
    else
        echo "⚠️ صلاحيات root غير متاحة. تنظيف الكاش محدود."
        echo "$(date) : تنظيف محدود بدون root" >> "$LOGFILE"
    fi

    # كشف العمليات الثقيلة
    echo "🔍 التطبيقات الثقيلة:"
    ps -eo pid,pmem,comm --sort=-pmem | awk -v threshold=$THRESHOLD '$2>threshold {print $0}' | while read pid mem cmd; do
        echo "⚠️ سيتم إغلاق العملية: $cmd (PID: $pid) تستخدم $mem% من RAM"
        echo "$(date) : قتل العملية $cmd (PID: $pid) تستهلك $mem%" >> "$LOGFILE"
        kill -9 $pid 2>/dev/null
    done

    # عرض حالة الذاكرة وتسجيلها
    free -h | tee -a "$LOGFILE"

    echo -e "\a"
    echo "⏱️ الانتظار $INTERVAL ثانية قبل التنظيف التالي..."
    echo "---- $(date) : نهاية دورة التنظيف ----" >> "$LOGFILE"
    sleep $INTERVAL
done
