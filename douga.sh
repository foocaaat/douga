#!/usr/bin/bash
path="youtube/"

if [ -n "$1" ]; then
  if [ ! -f "$HOME/.cache/douga" ]; then
    echo "Creating $1 file..."
    touch "$HOME/.cache/douga"
  fi

  current_date=$(cat $HOME/.cache/morning | awk '{print $1;}')
  id=$(echo "$1" | sed -n 's/.*youtube.com\/watch?v=\([^&]*\)\(&.*\)\{0,1\}$/\1/p')
  echo $current_date $id >> "$HOME/.cache/douga"
  yt-dlp --path youtube -f b -o "%(id)s.%(ext)s" $1
  echo "Added '$id' to $1 file."
  exit
exit
fi

print_today_lines() {
  while IFS= read -r line; do
        space=$(echo $(( ($(date --date="$current_date" +%s) - $(date --date="$(echo "$line" | awk '{print $1}')" +%s) )/(60*60*24) )))
        for n in "${numbers[@]}"; do
          if [ "$n" -eq "$space" ]; then
            id="$(echo "$line" | awk '{print $2}' )"
            items="$items $path$id.mp4"
            items2=$items2,$id
          fi
        done
  done < "$HOME/.cache/douga"

}

current_date=$(cat $HOME/.cache/morning | awk '{print $1;}')
numbers=(1 5 13 29 61 125 253 509 1021 2045 4093)
print_today_lines

if [[ $items != "" ]]
then
echo https://www.youtube.com/watch_videos?video_ids=$(echo $items2 | cut -c 2-) | xclip -selection clipboard
mpv --input-conf=$HOME/youtube/input.conf --no-osc --video-aspect=16:9 --volume=30 --loop-playlist $items &
sleep 5
i3-msg [class="mpv"] sticky enable, floating enable, resize set 400px 300px, move position  1505px 815px
fi
