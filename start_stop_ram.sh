#!/data/data/com.termux/files/usr/bin/bash
PAUSE_FLAG=~/pi_hackathon25/pause.flag
SCRIPT=~/pi_hackathon25/ram_swap_final_v4.sh

# إذا السكريبت ما خدامش، شغلو
if ! pgrep -f ram_swap_final_v4.sh > /dev/null; then
    echo "🚀 تشغيل السكريبت..."
    nohup bash $SCRIPT > ~/pi_hackathon25/ram_swap_widget.log 2>&1 &
    exit
fi

# إذا السكريبت شغال، عمل toggle بين pause/resume
if [ -f "$PAUSE_FLAG" ]; then
    rm "$PAUSE_FLAG"
    echo "▶️ استئناف السكريبت."
else
    touch "$PAUSE_FLAG"
    echo "⏸️ إيقاف مؤقت السكريبت."
fi
