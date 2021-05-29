gopass ls --flat | rofi -dmenu | xargs --no-run-if-empty gopass show -c
# gopass ls --flat | rofi -dmenu -p gopass | xargs --no-run-if-empty gopass show -f | head -n 1 | ydotool type --clearmodifiers --file -
