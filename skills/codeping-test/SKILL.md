---
description: Send a test notification to verify CodePing is working
---

Send a test notification to verify CodePing is configured correctly on this machine.

Execute:

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/notify.sh test
```

If you receive a notification on your device with the message "CodePing is working!" — everything is set up correctly.

If you don't receive anything:
1. Check that `~/.codeping/config` exists (run `/codeping-setup` if not)
2. Confirm you're subscribed to the correct topic in the ntfy app
3. Check internet connectivity on this machine
