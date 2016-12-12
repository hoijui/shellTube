#####################
# Name: yt-meta.sh
# Date: 2016-12-10
# Lisc: ISC
# Main: jadedctrl
# Desc: Fetches metadata about
#       a specific YT video.
#####################

# Usage: yt-meta.sh $video_id

if echo "$1" | grep "youtube.com"
then 
    id="$(echo $1 | sed 's/.*video_id=//')"
elif [ -z $1 ]
then
    "No video specified."
    exit 1
else
    id="$1"
fi


video_file="/tmp/yt-video_$RANDOM"
if type "wget" &> /dev/null
then
    wget -q https://youtube.com/watch?v=$id -O $video_file
    wget -q https://youtube.com/results?search_query=$id -O $video_file.1
elif type "curl" &> /dev/null
then
    curl -s https://youtube.com/watch?v=$id -o $video_file
    curl -s https://youtube.com/results?search_query=$id -o $video_file.1
fi

# Now for displaying the metadata
title="$(grep "\"title\":\"" $video_file | sed 's/.*"title":"//' | sed 's/".*//')"
author="$(grep "\"author\":\"" $video_file | sed 's/.*"author":"//' | sed 's/".*//')"
views="$(grep "\"view_count\":\"" $video_file | sed 's/.*"view_count":"//' | sed 's/".*//')"
duration="$(grep "<a href=\"/watch?v=$1" $video_file.1 | sed 's/.*Duration: //' | sed 's/\..*//')"
date="$(grep "datePublished" $video_file | sed 's/.*"datePublished" content="//' | sed 's/".*//')"
echo "$title"
echo "$author | $views | $duration | $date | $1"
