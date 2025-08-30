#!/data/data/com.termux/files/usr/bin/bash
PAUSE_FLAG=~/pi_hackathon25/pause.flag
SCRIPT=~/pi_hackathon25/ram_swap_final_v4.sh

# تحقق إذا السكريبت شغال
if pgrep -f ram_swap_final_v4.sh > /dev/null; then
    if [ -f "$PAUSE_FLAG" ]; then
        echo "⏸️ مؤقت"
    else
        echo "🟢 شغال"
    fi
else
    echo "⚪ متوقف"
fi
