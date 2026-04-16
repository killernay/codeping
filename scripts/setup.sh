#!/bin/bash
# CodePing - setup.sh
# First-run setup: generates ntfy topic, writes config, prints QR code

set -e

CONFIG_DIR="$HOME/.codeping"
CONFIG="$CONFIG_DIR/config"

echo ""
echo "  ╔═══════════════════════════════╗"
echo "  ║         CodePing Setup        ║"
echo "  ╚═══════════════════════════════╝"
echo ""

# Device name
DEFAULT_DEVICE=$(hostname | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g')
read -p "  Device name [$DEFAULT_DEVICE]: " DEVICE_NAME
DEVICE_NAME="${DEVICE_NAME:-$DEFAULT_DEVICE}"

# ntfy server
read -p "  ntfy server [https://ntfy.sh]: " NTFY_SERVER
NTFY_SERVER="${NTFY_SERVER:-https://ntfy.sh}"

# Generate topic
SECRET=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-z0-9' | head -c 4)
NTFY_TOPIC="codeping-${DEVICE_NAME}-${SECRET}"

# Language
echo ""
echo "  Notification language:"
echo "  1) English (default)"
echo "  2) Thai (ภาษาไทย)"
read -p "  Choice [1]: " LANG_CHOICE
if [ "$LANG_CHOICE" = "2" ]; then
  LANGUAGE="th"
else
  LANGUAGE="en"
fi

# Write config
mkdir -p "$CONFIG_DIR"
cat > "$CONFIG" << EOF
# CodePing config
# Generated: $(date)

DEVICE_NAME=$DEVICE_NAME
NTFY_SERVER=$NTFY_SERVER
NTFY_TOPIC=$NTFY_TOPIC
LANGUAGE=$LANGUAGE
EOF

echo ""
echo "  ✅ Config saved to $CONFIG"
echo ""
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  📱 Subscribe on your device:"
echo ""
echo "  Topic URL:"
echo "  ${NTFY_SERVER}/${NTFY_TOPIC}"
echo ""

# Print QR code if qrencode is available
if command -v qrencode &> /dev/null; then
  echo "  Scan QR to subscribe:"
  qrencode -t ANSI "${NTFY_SERVER}/${NTFY_TOPIC}"
else
  echo "  (Install qrencode for QR code: brew install qrencode)"
fi

echo ""
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Install ntfy app:"
echo "  iOS:     https://apps.apple.com/app/ntfy/id1625396347"
echo "  Android: https://play.google.com/store/apps/details?id=io.heckel.ntfy"
echo "  Other:   ${NTFY_SERVER}/${NTFY_TOPIC} (web push)"
echo ""

# Send test notification
echo "  Sending test notification..."
curl -s \
  -H "Title: ${DEVICE_NAME}" \
  -H "Priority: default" \
  -H "Tags: bell" \
  -d "[codeping] Setup complete! 🎉" \
  "${NTFY_SERVER}/${NTFY_TOPIC}" > /dev/null

echo "  ✅ Test notification sent!"
echo ""
echo "  CodePing is ready. Claude Code will notify you automatically."
echo ""
