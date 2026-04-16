#!/bin/bash
# CodePing - notify.sh
# Sends push notification via ntfy when Claude Code hooks fire

CONFIG="$HOME/.codeping/config"

if [ ! -f "$CONFIG" ]; then
  echo "[CodePing] Not configured. Run /codeping-setup first." >&2
  exit 0
fi

source "$CONFIG"

EVENT=$1
PROJECT=$(basename "${CLAUDE_CWD:-$(pwd)}")
HOOK_INPUT="${CLAUDE_HOOK_INPUT:-"{}"}"
EXIT_CODE=$(echo "$HOOK_INPUT" | jq -r '.exit_code // 0' 2>/dev/null || echo "0")

case "$EVENT" in
  notification)
    if [ "${LANGUAGE:-en}" = "th" ]; then
      MSG="รอคำสั่งต่อไป"
    else
      MSG="Waiting for input"
    fi
    PRIORITY="high"
    TAGS="yellow_circle"
    ;;
  stop)
    if [ "$EXIT_CODE" = "0" ]; then
      if [ "${LANGUAGE:-en}" = "th" ]; then
        MSG="เสร็จแล้ว"
      else
        MSG="Task complete"
      fi
      PRIORITY="default"
      TAGS="white_check_mark"
    else
      if [ "${LANGUAGE:-en}" = "th" ]; then
        MSG="หยุดด้วย error (exit $EXIT_CODE)"
      else
        MSG="Error (exit $EXIT_CODE)"
      fi
      PRIORITY="urgent"
      TAGS="red_circle"
    fi
    ;;
  test)
    MSG="CodePing is working!"
    PRIORITY="default"
    TAGS="bell"
    ;;
  *)
    exit 0
    ;;
esac

curl -s \
  -H "Title: ${DEVICE_NAME:-$(hostname)}" \
  -H "Priority: $PRIORITY" \
  -H "Tags: $TAGS" \
  -d "[$PROJECT] $MSG" \
  "${NTFY_SERVER:-https://ntfy.sh}/${NTFY_TOPIC}" \
  > /dev/null
