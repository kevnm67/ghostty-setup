#!/bin/sh
pane_index=$1
pane_path=$2
pane_cmd=$3
is_active=$4

case $pane_index in
1) bg="#52b87a" ;;
2) bg="#7fb6ed" ;;
3) bg="#d99530" ;;
4) bg="#f88aaf" ;;
5) bg="#32c5d2" ;;
*) bg="#ad95e9" ;;
esac

dir=$(basename "$pane_path")
printf "#[bg=%s,fg=#28262b,bold]  %s  %s  %s  " "$bg" "$pane_index" "$dir" "$pane_cmd"

if [ "$is_active" = "1" ]; then
    branch=$(cd "$pane_path" 2>/dev/null && git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "~")
    printf "#[bg=#3d3b42,fg=#d99530,bold]  %s  " "$branch"
fi
