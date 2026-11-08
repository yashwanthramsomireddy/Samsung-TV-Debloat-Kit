# 🚀 YASH // Tizen OS Remote Console & Debloat Guide
> **Developer & Author:** Yash92Duster  
> **Target Platform:** Samsung Smart TVs running Tizen OS  
> **Script File:** `debloat_tizen.bat`

---

## 📌 Overview

**YASH Tizen OS Remote Console** is a lightweight, zero-dependency Windows batch utility designed to safely manage, inspect, sideload, and debloat Samsung Smart TVs via SDB (Smart Development Bridge).

It is specifically engineered to bypass retail TV security restrictions (such as connection dropouts and `"closed"` socket errors) by enforcing root user scope execution (`shell 0`) and utilizing native SDB protocol handlers.

---

## 🛠️ Key Features & Capabilities

### 1. Zero-Crash Terminal Engine
* **Clean ASCII Branding:** Clean **YASH** header designed for 100% compatibility across all Windows Command Prompt encodings without character corruption.
* **Syntax & Escape Protection:** Quoted variable evaluation and sanitized string blocks prevent CMD window crashes or unexpected terminations.
* **Auto SDB Resolution:** Automatically detects `sdb.exe` in the local directory or relative paths before establishing daemon links.

### 2. Retail Firmware Stability Protocols
* **User Scope `0` Execution:** Bypasses non-interactive tty socket disconnects (`closed` error) by executing shell subcommands under root scope `0`.
* **Native SDB Package Uninstallation:** Uses `sdb uninstall <pkg_id>` instead of restricted internal tools (`vd_appuninstall`) to ensure stability.

### 3. Integrated Debloat & Package Management
* **System Catalog Inspection:** Instantly fetch and output all installed user, web-container, and system application IDs.
* **One-Click Debloat Verification:** Verify debloat status and safely purge unlocked user-facing bloatware without risking system boot loops or menu crashes.
* **Custom App Sideloading:** Deploy `.wgt` (Web Apps) or `.tpk` (Tizen Native Packages) directly from the script's root folder.
* **Remote App Controller:** Remotely launch (`app_launcher -s`) or force-kill (`app_launcher -k`) running apps via their Tizen App IDs.

---

## 🎮 Command Menu Reference

| Option | Feature | Under-the-Hood Command | Description |
| :---: | :--- | :--- | :--- |
| **`[1]`** | **List Installed Apps** | `sdb shell 0 applist` | Reads and outputs the complete active application catalog. |
| **`[D]`** | **Debloat Verification** | *System Audit Routine* | Checks system status and verifies that target user bloatware has been purged. |
| **`[2]`** | **Uninstall Package** | `sdb uninstall <AppID>` | Safely uninstalls user-installed or Store apps by package ID. |
| **`[3]`** | **Sideload Package** | `sdb install <file>` | Transfers and deploys `.wgt` or `.tpk` packages to the TV. |
| **`[4]`** | **Launch Application** | `sdb shell 0 execute <AppID>` | Sends an execution signal to launch an installed app remotely. |
| **`[5]`** | **Force-Kill Process** | `sdb shell 0 kill <AppID>` | Sends a `SIGKILL` signal to terminate stuck or unresponsive apps. |
| **`[6]`** | **System Capabilities** | `sdb capability` | Displays detailed hardware specs, display resolution, and OS features. |
| **`[7]`** | **Resource Monitor** | `sdb shell 0 top -n 1` | Displays a real-time snapshot of system CPU and RAM utilization. |
| **`[8]`** | **Verify Link** | `sdb devices` | Verifies network link status and active target device identification. |
| **`[9]`** | **Change TV IP** | *Re-initializes Session* | Reconnects or switches the active target IP address without restarting CMD. |
| **`[0]`** | **Terminate & Exit** | `sdb disconnect <IP>` | Gracefully disconnects the SDB session and closes the console cleanly. |

---

## 🔒 Debloat Safety Audit Matrix

When debloating Tizen OS, package types behave according to the following rules:

### 🟢 Removable / Safe Bloatware (Purgeable via Option 2 or Option D)
* **Samsung TV Plus:** `com.samsung.tv.tvPlusDeeplinker`
* **Spotify App & Recommendations:** `rJeHak5zRg.Spotify`, `rJeHak5zRg.SpotifyService`
* **Apple AirPlay Receiver:** `NRi6kdBYJ0.AirPlayWebApp`
* **Store-Installed Apps:** Any app manually downloaded from the Samsung App Store or sideloaded.

### 🟡 Pre-Locked System Apps (Returns `Operation not allowed [-4]`)
* **Netflix:** `org.tizen.netflix-app`
* **Demo Players:** `org.tizen.demo-player-tv`, `org.tizen.internal-demo-player-tv`
* **HereMaps UI:** `org.tizen.heremaps-uc`
* *Note:* These are hardcoded into the read-only `/usr/apps/` partition. They cannot be uninstalled without root Partner certificates, but they can be removed/hidden from the Smart Hub dock on the TV.

### 🔴 Unsafe OS Core Framework (DO NOT TOUCH)
* Packages starting with `org.tizen.*` (e.g., `org.tizen.menu`, `org.tizen.volume-setting`, `org.tizen.hdmicec`) or `com.samsung.tv.*` (e.g., `com.samsung.tv.iot-dashboard`) handle fundamental TV functions (HDMI CEC, volume OSD, TV settings, and remote control input).

---

## 📋 Quick Start Setup

1. **Enable Developer Mode on TV:**
   * Open the **Apps** panel on your Samsung Smart TV.
   * Press `1` `2` `3` `4` `5` on your remote.
   * Toggle **Developer Mode** to **ON**.
   * Enter your local PC IP address and restart the TV by holding the Power button on the remote for 5 seconds.
2. **Execute Script:**
   * Place `sdb.exe` (and required SDB support libraries) in the same directory as `debloat_tizen.bat`.
   * Double-click `debloat_tizen.bat`.
   * Input your TV's IPv4 address (e.g., `192.168.1.8`) when prompted to establish the link.