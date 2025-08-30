#!/data/data/com.termux/files/usr/bin/bash
# سكريبت تنظيف RAM تلقائيًا كل فترة معينة

# المدة بالثواني بين كل تنظيف (مثال: 300 ثانية = 5 دقائق)
INTERVAL=300

echo "🔹 تنظيف RAM تلقائي كل $INTERVAL ثانية"

while true; do
    echo "⏳ تنظيف RAM جاري..."
    sync
    if [ "$(id -u)" -eq 0 ]; then
        echo 3 > /proc/sys/vm/drop_caches
        echo "✅ RAM تم تنظيفها بالكامل."
    else
        echo "⚠️ صلاحيات root غير متاحة. تنظيف الكاش محدود."
    fi
    free -h
    echo "⏱️ الانتظار $INTERVAL ثانية قبل التنظيف التالي..."
    sleep $INTERVAL
done
