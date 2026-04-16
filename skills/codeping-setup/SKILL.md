---
description: Set up CodePing notifications for this machine
---

Run the CodePing setup script to configure push notifications for this machine.

Execute the following command and follow the prompts:

```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/setup.sh
```

After setup is complete:
1. Install the ntfy app on your device (iOS / Android / Mac / Windows / Linux)
2. Subscribe to the topic URL shown during setup (or scan the QR code)
3. CodePing will now notify you whenever Claude needs input or completes a task

To send a test notification after setup, run:
```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/notify.sh test
```
