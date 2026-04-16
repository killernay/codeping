# CodePing

> Push notifications from Claude Code to any device, anywhere in the world.

You're deep in a vibe coding session — 4, maybe 10 projects running at once across different machines. One finishes on your office Mac. Another is waiting for input on a cloud server. A third just crashed on your VPS. But you're staring at the wrong terminal.

**CodePing fixes that.** It pings your phone the moment any Claude Code session needs attention — which machine, which project, what happened. You switch back, pick up where you left off, and keep the flow going.

```
Claude Code → ntfy → 📱 iPhone + ⌚ Watch
                   → 🤖 Android + Wear OS  
                   → 💻 Mac / Windows / Linux
```

Works on every device, every OS, every network. Even from a remote server on the other side of the world.

---

## Why CodePing?

| | Taphaptic | CodePing |
|---|---|---|
| iPhone + Apple Watch | ✅ | ✅ |
| Android + Wear OS | ❌ | ✅ |
| Mac / Windows / Linux | ❌ | ✅ |
| Remote machine / VPS | ❌ | ✅ |
| Cloud server / CI | ❌ | ✅ |
| Multiple machines | ❌ | ✅ |
| Cost | Free | Free |
| Requires LAN | ✅ | ❌ |

---

## Install

**Step 1** — Add marketplace and install plugin (inside Claude Code):

```
/plugin marketplace add killernay/codeping
/plugin install codeping@killernay
```

**Step 2** — Run setup:

```
/codeping-setup
```

**Step 3** — Install [ntfy app](https://ntfy.sh) on your device and subscribe to the topic shown during setup.

That's it. Claude Code will now notify you automatically.

---

## What you'll receive

| Event | Notification | Priority |
|---|---|---|
| Claude waiting for input | `[ProjectName] Waiting for input` | 🟡 High |
| Task complete | `[ProjectName] Task complete` | ✅ Default |
| Claude stopped with error | `[ProjectName] Error (exit 1)` | 🔴 Urgent |

Notifications include the **machine name** and **project name** so you always know which one needs attention.

---

## Multiple machines

Run `/codeping-setup` on each machine separately. Each machine gets its own ntfy topic:

```
codeping-macstudio-x7k2
codeping-office-mbp-a3f9
codeping-vps-prod-m2k8
```

Subscribe to each topic in ntfy — or use ntfy's wildcard subscription to receive all machines in one feed.

---

## Configuration

Config is stored at `~/.codeping/config`:

```bash
DEVICE_NAME=macstudio
NTFY_SERVER=https://ntfy.sh    # or your self-hosted ntfy
NTFY_TOPIC=codeping-macstudio-x7k2
LANGUAGE=en                     # en | th
```

### Self-hosted ntfy

Set `NTFY_SERVER` to your own ntfy instance for full privacy:

```bash
NTFY_SERVER=https://ntfy.yourdomain.com
```

---

## Receive notifications

### iOS (iPhone + Apple Watch)

1. Install [ntfy from the App Store](https://apps.apple.com/app/ntfy/id1625396347)
2. Open ntfy → tap **+** (top right)
3. Paste your topic URL shown during `/codeping-setup` (e.g. `https://ntfy.sh/codeping-macstudio-x7k2`)
4. Tap **Subscribe**
5. Allow notifications when prompted
6. **Important:** If you use Focus mode (Work, Do Not Disturb, etc.), go to **Settings → Focus → [Your Focus] → Apps → Add ntfy** to allow notifications during Focus mode. Otherwise you won't receive CodePing alerts while Focus is active.

Apple Watch receives notifications automatically — no extra setup needed.

### Android (Phone + Wear OS)

1. Install [ntfy from Play Store](https://play.google.com/store/apps/details?id=io.heckel.ntfy)
2. Open ntfy → tap **+** (bottom right)
3. Enter your topic name shown during `/codeping-setup` (e.g. `codeping-macstudio-x7k2`)
4. Tap **Subscribe**
5. **Important:** If you use Focus / Do Not Disturb mode, go to **Settings → Sound & vibration → Do Not Disturb → Apps → Add ntfy** to allow notifications during DND.

Wear OS receives notifications automatically if paired with phone.

### Mac / Windows / Linux

**Option A — Browser push:**
1. Go to `https://ntfy.sh/YOUR_TOPIC` in your browser
2. Click **Subscribe** and allow notifications

**Option B — ntfy CLI (Linux/Mac):**
```bash
ntfy subscribe codeping-macstudio-x7k2
```

### All platforms

| Platform | App |
|---|---|
| iOS + Apple Watch | [ntfy on App Store](https://apps.apple.com/app/ntfy/id1625396347) |
| Android + Wear OS | [ntfy on Play Store](https://play.google.com/store/apps/details?id=io.heckel.ntfy) |
| Mac | [ntfy on Mac App Store](https://apps.apple.com/app/ntfy/id1625396347) or browser |
| Windows / Linux | [ntfy web push](https://ntfy.sh) or [ntfy CLI](https://docs.ntfy.sh/subscribe/cli/) |

---

## Languages

CodePing supports `en` (default) and `th`. Set `LANGUAGE=th` in `~/.codeping/config` for Thai notifications.

Want to add your language? PRs welcome — edit the `case` block in `scripts/notify.sh`.

---

## Manual install (no plugin system)

If you prefer not to use the plugin marketplace, add this to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "Notification": [{
      "matcher": "",
      "hooks": [{ "type": "command", "command": "/path/to/codeping/scripts/notify.sh notification" }]
    }],
    "Stop": [{
      "matcher": "",
      "hooks": [{ "type": "command", "command": "/path/to/codeping/scripts/notify.sh stop" }]
    }]
  }
}
```

Then run `scripts/setup.sh` manually.

---

## License

MIT — [Chanon Ngernthongdee](https://github.com/killernay) · [Twitter/X](https://x.com/killernay)
