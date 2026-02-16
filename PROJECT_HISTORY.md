# Project History & Management Guide

## 📜 Project Life History (Chronological)

A summary of the project's evolution based on source control records.

### **Phase 4: Android Refinement (Feb 2026)**
-   **2026-02-14 (Evening):** **v2.9.0 Export Stability** — Refactored HTML Export specific logic to use Data Attributes (fixing syntax errors with quotes). Organized project into explicit `Android`, `PWA`, and `Windows` directories.
-   **2026-02-14 (Morning):** **v2.8.0 Android Fixes** — Fixed Sync Restore (folder scan + file picker crash), added CSV RowNum/ID, standardized timestamps. Isolated Android build to `ShelfLife_Android/`.
-   **2026-02-02:** **v2.6.0/v2.6.1** — Added BulkEdit with Wildcard Find/Replace. Fixed window size and sync for Windows/Tauri.

### **Phase 3: Windows Desktop & Polish (Jan 2026)**
-   **2026-01-10:** **v2.5.3 - v2.5.7** — Critical fixes for Clipboard Paste, HTML tags, and localized library dependencies (React/Dexie included in repo).
-   **2026-01-09:** **v2.5.0 Windows Release** — Launched Windows EXE build via Tauri. Added ISBN input, Image Capture, and HTML Dashboard.
-   **2026-01-02:** **v2.5.0 Android Stability** — Major fix for Barcode Scanner (switched to Capacitor MLKit), Camera permissions, and Sync Folder bugs.

### **Phase 2: Core Features & Sync (Late Dec 2025)**
-   **2025-12-31:** **v2.3.0 Tag Manager** — Full-featured Tag Manager, Export Images to ZIP (chunked).
-   **2025-12-27:** **v2.0.0 Smart Features** — Implemented Smart Restore (multi-file), Backup Signatures (device model), and Persistent Keystore.
-   **2025-12-25:** **Multi-Device Sync** — First implementation of Sync logic, Restore Modes (Replace/Append/Merge), and Device ID.
-   **2025-12-24:** **Voice & Offline** — Added Native Speech Recognition, Offline Google Fonts, and Visual Folder Picker.

### **Phase 1: Inception (Mid Dec 2025)**
-   **2025-12-20:** **Initial PWA & Cloud Build** — Project initialized as "ShelfLife Ultimate PWA". Setup Google Cloud Build workflow.

---

## 🛡️ Edition Management Guide

You have three distinct editions: **Android**, **Windows**, and **PWA**. Here are two strategies to manage them without "messing up".

### Strategy A: "Folder Isolation" (Current, Easiest)
**Concept:** Keep physically separate folders for each platform.
-   `ShelfLife_Android/` (contains its own `index.html`)
-   `ShelfLife_Windows/` (contains its own `index.html`)
-   `ShelfLife_PWA/` (or root `index.html`)

**✅ Pros:**
-   **Visual Safety:** You know exactly which one you are editing by looking at the folder path.
-   **Independent Builds:** You can break the Android code without stopping the Windows app from working.

**❌ Cons:**
-   **Code Drift:** If you add a cool feature to Android, you must *manually copy-paste* it to Windows and PWA. They will drift apart over time.

**Workflow:**
1.  **To Edit Android:** Open `ShelfLife_Android/index.html`.
2.  **To Edit Windows:** Open `ShelfLife_Windows/index.html`.
3.  **To Backup:** Copy the whole folder (e.g., `ShelfLife_Android_Backup_Feb14`).

---

### Strategy B: "Git Branching" (Professional, Recommended for Long Term)
**Concept:** Use one main folder, but switch "timelines" (branches) for each edition.

**Structure:**
-   **`main` branch:** The core PWA code (Gold standard).
-   **`android` branch:** Based on main, but adds Android-specific plugins/fixes.
-   **`windows` branch:** Based on main, but adds Tauri config/fixes.

**✅ Pros:**
-   **Unified Core:** Fix a bug in `main`, then "merge" it into `android` and `windows`. All editions get the fix instantly.
-   **Clean:** No duplicate `index.html` files confusing you.

**❌ Cons:**
-   **Complexity:** Requires knowing Git commands (`checkout`, `merge`).
-   **Invisible State:** You can't "see" the Android code while working on Windows code (unless you switch branches).

**Workflow:**
1.  **Start:** `git checkout main` (Work on PWA).
2.  **Work on Android:** `git checkout android` (Files magically change to Android version).
3.  **Update Android with PWA changes:**
    ```bash
    git checkout android
    git merge main  # Pulls in latest PWA features
    ```

### My Recommendation
**Stick with Strategy A (Folder Isolation) for now.**
Since you already have the physical folders set up (`ShelfLife_Android`, `ShelfLife_Windows`), it is the path of least resistance.
*   **Safety Rule:** Never open the root `index.html` if you intend to work on an app. Always go into the subfolder.
*   **Synchronization:** Periodically (e.g., once a month), you might want to "port" features. You can ask me: *"Please port the Dashboard feature from Windows to the Android version."*
