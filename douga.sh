#!/usr/bin/bash


if [ -n "$1" ]; then
  if [ ! -f "$HOME/.cache/douga" ]; then
    echo "Creating $1 file..."
    touch "$HOME/.cache/douga"
  fi

  current_date=$(cat $HOME/.cache/morning | awk '{print $1;}')
  id=$(echo "$2" | sed -n 's/.*youtube.com\/watch?v=\([^&]*\)\(&.*\)\{0,1\}$/\1/p')
  echo $current_date $id >> "$HOME/.cache/douga"
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
            items=$items,$id
          fi
        done
  done < "$HOME/.cache/douga"

}

current_date=$(cat $HOME/.cache/morning | awk '{print $1;}')
numbers=(1 5 13 29 61 125 253 509 1021 2045 4093)
print_today_lines

if [[ $items != "" ]]
then
echo https://www.youtube.com/watch_videos?video_ids=$(echo $items | cut -c 2-) 
librewolf --new-tab https://www.youtube.com/watch_videos?video_ids=$(echo $items | cut -c 2-) 
echo https://www.youtube.com/watch_videos?video_ids=$(echo $items | cut -c 2-) | xclip -selection clipboard
fi
