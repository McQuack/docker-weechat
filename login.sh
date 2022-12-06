#!/bin/bash

function start_weechat()
{
  if [ -f "/home/weechat/.weechat/irc.conf" ] ; then
    weechat
  else
    weechat -r "/proxy add tor socks5 127.0.0.1 9050"
  fi
}

function start_tmux()
{
  if tmux has-session -t WeeChat 2>/dev/null; then
    tmux attach -t WeeChat
  else
    tmux new -s WeeChat "$0"
  fi
}

if test $TMUX; then
  start_weechat
else
  start_tmux
fi
