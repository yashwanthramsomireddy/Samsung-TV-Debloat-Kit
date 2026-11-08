# PROJECT CONTEXT & ARCHITECTURE: YASH Tizen OS Remote Console & Debloat Kit

## 1. Project Identity & Target
- **Project Name:** YASH Tizen OS Remote Console (`debloat_tizen.bat`)
- **Author / Brand:** Yash92Duster (YASH)
- **Target Hardware:** Samsung QLED Smart TV (Model: QA55Q7FNA, Firmware: `T-KTM2UABC-1360.0`)
- **Core Utility:** A robust Windows batch script (`debloat_tizen.bat`) combined with Samsung SDB (`sdb.exe`) for remote debugging, package management, app sideloading, and debloating.

---

## 2. Technical Architecture & Constraints
- **SDB Scope Rule:** All SDB shell commands MUST execute under root user scope `0` (e.g., `sdb shell 0 applist`, `sdb shell 0 execute <id>`) to prevent non-interactive tty socket closures (`closed` error).
- **Firmware Protection & Error Codes:** 
  - Factory-locked system packages reside in read-only partitions (`/usr/apps/`) and return error `132` or `Operation not allowed [-4]` when deletion is attempted. The OS blocks these safely without risk of bricking.
  - User-installed store apps or optional bloatware return `val[ok]` and can be purged cleanly.
- **CMD Terminal Stability Rules:** 
  - To prevent CMD terminal windows from crashing or closing instantly upon execution, multi-line nested loops are avoided where possible, variables are safely quoted (`set "VAR=VAL"`), and unescaped special characters (`&`, `|`, `<`, `>`, `%`) are avoided in header/echo blocks.

---

## 3. Current Implementation Status & Audit Findings
- **Successfully Purged:** Samsung TV Plus (`com.samsung.tv.tvPlusDeeplinker`) has been fully uninstalled.
- **Permanent Prevention:** Turning off "Auto update" in the TV's App Store settings prevents background re-downloads of purged promotional packages. If any app returns via updates, it can be re-purged instantly via the script.
- **Companion Documentation:** A complete Markdown documentation guide (`README.md`) detailing menus, safety matrices, and setup instructions is maintained alongside the batch script.

---

## 4. Current Batch Script Menu Architecture (`debloat_tizen.bat`)
- `[1]` **List Installed Apps Catalog:** Executes `sdb shell 0 applist` to read active packages.
- `[D]` **Debloat Status:** System audit verification confirming the cleanup state.
- `[2]` **Uninstall Any Store / User App:** Executes `sdb uninstall <AppID>`.
- `[3]` **Sideload Custom Package:** Deploys local `.wgt` or `.tpk` packages via `sdb install`.
- `[4]` **Remotely Launch Application:** Executes `sdb shell 0 execute <AppID>`.
- `[5]` **Force-Kill Stuck App Process:** Sends `SIGKILL` via `sdb shell 0 kill <AppID>`.
- `[6]` **Display System Capabilities:** Runs `sdb capability`.
- `[7]` **Stream Live Resource Monitor:** Runs `sdb shell 0 top -n 1`.
- `[8]` **Verify Network Link Status:** Runs `sdb devices`.
- `[9]` **Reconnect / Change TV IP Address**
- `[0]` **Terminate Link and Exit**


Download web-cli_Tizen_SDK_10.0_usa_windows-64.exe from official site
https://samsungtizenos.com