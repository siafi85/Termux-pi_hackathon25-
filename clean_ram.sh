#!/data/data/com.termux/files/usr/bin/bash
# سكريبت تنظيف RAM في Termux بدون حذف الملفات

echo "🔹 تنظيف RAM جاري..."

# حفظ أي بيانات مؤقتة
sync

# محاولة تفريغ الكاش (PageCache, dentries, inodes)
if [ "$(id -u)" -eq 0 ]; then
    echo 3 > /proc/sys/vm/drop_caches
    echo "✅ RAM تم تنظيفها بالكامل."
else
    echo "⚠️ لا يوجد صلاحيات root. تنظيف الكاش محدود."
fi

# عرض استخدام الذاكرة بعد التنظيف
free -h
