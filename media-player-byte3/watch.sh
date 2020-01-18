#!/bin/bash
rclone -c /var/local/media-player/rclone.conf mount germinate: /media/germinate &
sleep 1
/var/local/media-player/noice /media/germinate
kill %1
