#!/usr/bin/bash
path="$HOME/douga"
current_date=$(cat $path/douga | head -1)
if [ "$1" == "morning" ]; then

if [ ! -f $path/douga ]; then
    date '+%Y-%m-%d' > $path/douga
else
    if [ "$(cat $path/douga | head -1)" == "" ];then
        date '+%Y-%m-%d' -d "$(cat $path/douga | head -1)" > $path/douga
    else
        todate=$(date -d $(date '+%Y-%m-%d') +%s)
        cond=$(date -d $(cat $path/douga | head -1) +%s )

        if [ $todate -gt $cond ];
        then
            sed -i.bak "1 s/.*/$(date '+%Y-%m-%d' -d "$(cat $path/douga | head -1) + 1 days")/" $path/douga

        else
            echo Yu have travel to the end of time 
        fi  

    fi
fi

    exit
fi
if [ "$1" == "--clean0000" ]; then
  while IFS= read -r line; do
            id="$(echo "$line" | awk '{print $2}' )"
            if [ ! -f "$path/$id" ]; then
                echo $path/$id
                sed -i "/$line/d" "$path/douga"
            fi
  done < "$path/douga"
  exit
fi

if [ "$1" == "-fc" ]; then
        echo feeeee
        if [ -f "$2" ]; then
            if [ ! -f $path/$(basename "$2"| replace ' '  '-') ]; then
                    echo copying
                    cp "$2" $path/$(basename "$2"| replace ' '  '-')
            fi
            if grep -q "$(basename "$2"| replace ' '  '-')" "$path/douga"; then
                echo The item is already present in the list.
            else
                echo $current_date $(basename "$2"| replace ' '  '-') >> "$path/douga"
            fi
            mpv $path/$(basename "$2"| replace ' '  '-') --no-config --no-sub --geometry=15%+1+1
        elif [ -f "$path/$id" ]; then
            echo it already exist
        else
            echo file where?
        fi
        exit
      # code to handle the -f option
      # $OPTARG contains the argument to the -f option
fi
if [ "$1" == "-fm" ]; then
        echo feeeee
        if [ -f "$2" ]; then
            if [ ! -f $path/$(basename "$2"| replace ' '  '-') ]; then
                    echo moving
                    mv "$2" $path/$(basename "$2"| replace ' '  '-')
            fi
            if grep -q "$(basename "$2"| replace ' '  '-')" "$path/douga"; then
                echo The item is already present in the list.
            else
                echo $current_date $(basename "$2"| replace ' '  '-') >> "$path/douga"
            fi
            mpv --fullscreen --no-sub --geometry=15%+1+1 $path/$(basename "$2"| replace ' '  '-') --no-config
        elif [ -f "$path/$id" ]; then
            echo it already exist
        else
            echo file where?
        fi
        exit
      # code to handle the -f option
      # $OPTARG contains the argument to the -f option
fi

if [ "$1" == "-y" ]; then
  if [ ! -f "$path/douga" ]; then
    echo "Creating $2 file..."
    touch "$path/douga"
  fi

  if [[ $2 =~ ^https://www.youtube.com/shorts/([a-zA-Z0-9_-]+)$ ]]; then
    pos=$(expr "$2" : '.*rts/')
    id=$(echo "$2" | cut -c $((pos+1))-$((pos+11)))
else
    pos=$(expr "$2" : '.*h?v=')
    id=$(echo "$2" | cut -c $((pos+1))-$((pos+11)))
  fi
    echo $id
  while [ ! -f "$path/$id" ] ; do
  yt-dlp --path $path -f b -o "%(id)s" -- $id
  done
  echo $current_date $id >> "$path/douga"
  echo "Added '$id' to $id file."
  exit
exit
fi

print_today_lines() {
  while IFS= read -r line; do
        space=$(echo $(( ($(date --date="$current_date" +%s) - $(date --date="$(echo "$line" | awk '{print $1}')" +%s) )/(60*60*24) )))
        for n in "${numbers[@]}"; do
          if [ "$n" -eq "$space" ]; then
            id="$(echo "$line" | awk '{print $2}' )"
                items="$items $path/$id"
                items2=$items2,$id
          fi
        done
  done < "$path/douga"

}

numbers=(1 5 13 29 61 125 253 509 1021 2045 4093)
print_today_lines $1
words=($items)
output=()

for (( i=0, j=${#words[@]}-1; i<=j; i++, j-- )); do
  output+=(${words[i]})
  if [[ $i != $j ]]; then
    output+=(${words[j]})
  fi
done

echo ${output[@]}

if [[ $items != "" ]]
then
mpv --no-sub --no-config --geometry=15%+1+1 --loop-playlist ${output[@]}
fi
