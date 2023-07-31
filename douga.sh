#!/usr/bin/bash
path="$HOME/youtube/"

if [ -n "$1" ]; then
if [ "$1" != "rev" ]; then
  if [ ! -f "$HOME/.cache/douga" ]; then
    echo "Creating $1 file..."
    touch "$HOME/.cache/douga"
  fi

  current_date=$(cat $HOME/.cache/morning | awk '{print $1;}')
  id=$(echo "$1" | sed -n 's/.*youtube.com\/watch?v=\([^&]*\)\(&.*\)\{0,1\}$/\1/p')
  yt-dlp --path youtube -f b -o "%(id)s" $id
  echo $current_date $id >> "$HOME/.cache/douga"
  echo "Added '$id' to $id file."
  exit
exit
fi
fi

print_today_lines() {
  while IFS= read -r line; do
        space=$(echo $(( ($(date --date="$current_date" +%s) - $(date --date="$(echo "$line" | awk '{print $1}')" +%s) )/(60*60*24) )))
        for n in "${numbers[@]}"; do
          if [ "$n" -eq "$space" ]; then
            id="$(echo "$line" | awk '{print $2}' )"
            if [ "$1" == "rev" ]; then
                items="$path$id $items"
                items2=$items2,$id
            else
                items="$items $path$id"
                items2=$id,$items2
            fi
          fi
        done
  done < "$HOME/.cache/douga"

}

current_date=$(cat $HOME/.cache/morning | awk '{print $1;}')
numbers=(1 5 13 29 61 125 253 509 1021 2045 4093)
print_today_lines $1

if [[ $items != "" ]]
then
echo https://www.youtube.com/watch_videos?video_ids=$(echo $items2 | cut -c 2-) | xclip -selection clipboard
mpv --input-conf=$HOME/youtube/input.conf --no-terminal --no-osc --geometry=15%+1-60 --volume=30 --loop-playlist $items
fi
