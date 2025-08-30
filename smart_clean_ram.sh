#!/data/data/com.termux/files/usr/bin/bash
# سكريبت تنظيف RAM ذكي في Termux

# المدة بالثواني بين كل تنظيف
INTERVAL=300

# نسبة RAM المستهلكة للتطبيقات الثقيلة (مثال: 10% = 10)
THRESHOLD=10

echo "🔹 تنظيف RAM ذكي كل $INTERVAL ثانية"

while true; do
    echo "⏳ تنظيف RAM جاري..."

    # تفريغ أي بيانات مؤقتة على التخزين
    sync

    # محاولة تفريغ الكاش إذا كان root
    if [ "$(id -u)" -eq 0 ]; then
        echo 3 > /proc/sys/vm/drop_caches
        echo "✅ RAM تم تنظيفها بالكامل."
    else
        echo "⚠️ صلاحيات root غير متاحة. تنظيف الكاش محدود."
    fi

    # عرض استخدام الذاكرة
    free -h

    # كشف العمليات الثقيلة
    echo "🔍 التطبيقات الثقيلة:"
    ps -eo pid,pmem,comm --sort=-pmem | head -n 10 | awk -v threshold=$THRESHOLD '$2>threshold {print $0}'

    # إشعار صغير (إذا Termux يدعم الصوت)
    echo -e "\a"

    echo "⏱️ الانتظار $INTERVAL ثانية قبل التنظيف التالي..."
    sleep $INTERVAL
done
