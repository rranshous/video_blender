#!/usr/bin/env bash


# convert both videos to standard
ffmpeg -i $1 \
  -codec:v libx264 \
  -profile:v main \
  -preset fast \
  -b:v 500k \
  -maxrate 500k \
  -bufsize 1000k \
  -vf scale=-1:480 \
  -threads 0 \
  /tmp/1.mp4

ffmpeg -i $2 \
  -codec:v libx264 \
  -profile:v main \
  -preset fast \
  -b:v 500k \
  -maxrate 500k \
  -bufsize 1000k \
  -vf scale=-1:480 \
  -threads 0 \
  /tmp/2.mp4

#ffmpeg \
#  -i /tmp/1.mp4 \
#  -i /tmp/2.mp4 \
#  -filter_complex "blend=all_mode='addition':all_opacity=0.7" \
#  "$3"

ffmpeg -i "/tmp/1.mp4" -i "/tmp/2.mp4" \
  -filter_complex "[1:0] setsar=sar=1,format=rgba [1sared]; [0:0]format=rgba [0rgbd]; [0rgbd][1sared]blend=all_mode='addition':repeatlast=1:all_opacity=1,format=yuva422p10le" \
  -c:v libx264 -preset slow -tune film -crf 19 \
  -c:a aac -strict -2 -ac 2 -b:a 256k \
  -pix_fmt yuv420p "$3"
