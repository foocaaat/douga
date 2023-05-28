#!/usr/bin/bash

function get_id() {
  local url="$1"
  local id
  id=$(echo "$url" | sed -n 's/.*youtube.com\/watch?v=\([^&]*\)\(&.*\)\{0,1\}$/\1/p')
  echo "$id"
}

if [ -n "$1" ]; then
if [ -n "$2" ]; then
  if [ ! -f "$HOME/.cache/douga" ]; then
    echo "Creating $1 file..."
    touch "$HOME/.cache/douga"
  fi

  current_date=$(cat $HOME/.cache/morning | awk '{print $1;}')
  echo "$current_date $(get_id $2)" $1>> "$HOME/.cache/douga"
  echo "Added '$2' to $1 file."
  exit
else
echo what video
exit
fi
fi

print_today_lines() {
  while IFS= read -r line; do
        input_date=$(echo "$line" | awk '{print $1}')
        line_date_seconds=$(date -d "$input_date" +%s)
        days=
        while [ $line_date_seconds -le $current_date_seconds ]
        do
            if [ $line_date_seconds -eq $current_date_seconds ]
            then
                # Echo hay and break the loop
                if [ "$(echo "$line" | awk '{print $3}' )" == "jp" ]; then
                jp=$jp,$(echo "$line" | awk '{print $2}')
                fi
                if [ "$(echo "$line" | awk '{print $3}' )" == "ko" ]; then
                ko=$ko,$(echo "$line" | awk '{print $2}')
                fi
                if [ "$(echo "$line" | awk '{print $3}' )" == "sp" ]; then
                sp=$sp,$(echo "$line" | awk '{print $2}')
                fi
                if [ "$(echo "$line" | awk '{print $3}' )" == "ch" ]; then
                ch=$ch,$(echo "$line" | awk '{print $2}')
                fi
                break
            fi
            input_date=$(date '+%Y-%m-%d' -d "$input_date + $days days")
            line_date_seconds=$(date -d "$input_date" +%s)
          days=$((days * 2))
          if [ $days -eq 0 ];then
              days=4
          fi
        done
  done < "$HOME/.cache/douga"

}

current_date=$(cat $HOME/.cache/morning | awk '{print $1;}')
current_date_seconds=$(date -d "$current_date" +%s)
print_today_lines
list=$jp$ko$sp$ch

if [[ $list != "" ]]
then
echo https://www.youtube.com/watch_videos?video_ids=$(echo $list | cut -c 2-) 
librewolf --new-tab https://www.youtube.com/watch_videos?video_ids=$(echo $list | cut -c 2-) 
echo https://www.youtube.com/watch_videos?video_ids=$(echo $list | cut -c 2-) | xclip -selection clipboard
fi
