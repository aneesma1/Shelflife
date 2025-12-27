# Home Library by Anees - Technical Documentation

## Overview
**Home Library by Anees** is a personal book cataloging Android application that works 100% offline. It allows users to manage their physical book collection with features like voice input, barcode scanning, multi-language support, and cloud backup.

---

## Technology Stack

| Layer | Technology | Purpose |
|-------|------------|---------|
| **Frontend** | React 18 | UI Components |
| **Styling** | TailwindCSS | Responsive design |
| **Database** | Dexie.js (IndexedDB) | Local offline storage |
| **Transpiler** | Babel | JSX in browser |
| **Barcode** | html5-qrcode | ISBN scanning |
| **Native Wrapper** | Capacitor 6 | Android APK packaging |
| **Build** | Google Cloud Build | CI/CD pipeline |

---

## Architecture

```
┌─────────────────────────────────────────────────┐
│                   index.html                     │
│  ┌───────────────────────────────────────────┐  │
│  │              React App                     │  │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────────┐  │  │
│  │  │ Library │ │ Search  │ │  Dashboard  │  │  │
│  │  │  View   │ │ (Slicer)│ │ (Analytics) │  │  │
│  │  └────┬────┘ └────┬────┘ └──────┬──────┘  │  │
│  │       │           │             │          │  │
│  │       └───────────┴─────────────┘          │  │
│  │                   │                        │  │
│  │         ┌─────────┴─────────┐              │  │
│  │         │    Dexie (DB)     │              │  │
│  │         │   IndexedDB v40   │              │  │
│  │         └───────────────────┘              │  │
│  └───────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
                      │
         ┌────────────┴────────────┐
         │   Capacitor Plugins     │
         ├─────────────────────────┤
         │ • Filesystem            │
         │ • App (Back Button)     │
         │ • Speech Recognition    │
         │ • File Picker           │
         └─────────────────────────┘
```

---

## Database Schema

**Database Name**: `ShelfLife_Final_v40`

| Field | Type | Description |
|-------|------|-------------|
| `id` | Auto-increment | Primary key |
| `title` | String | Book title |
| `phonetic` | String | Phonetic spelling |
| `author` | String | Author name |
| `owner` | String | Book owner |
| `publisher` | String | Publisher name |
| `language` | String | en/ml/ar/hi |
| `building` | String | Physical location |
| `shelf` | String | Shelf identifier |
| `status` | String | avail/reading/lent |
| `date_added` | Timestamp | Creation date |
| `isbn` | String | ISBN barcode |
| `page_count` | Number | Total pages |
| `condition` | String | Good/Fair/Torn/Loose |
| `currency` | String | ₹/$/QAR |
| `price` | Number | Book value |
| `front` | Base64 | Front cover image |
| `rear` | Base64 | Back cover image |
| `thumb` | Base64 | Thumbnail |
| `pages` | Array | Additional page images |
| `tags` | Array | Category tags |

---

## Core Features

### 1. Book Cataloging
- **Add/Edit/Delete** books with metadata
- **Image capture** (Front cover, Rear cover, Pages)
- **Auto-suggest** fields based on existing entries

### 2. Voice Input (Native)
- Uses `@capacitor-community/speech-recognition`
- **Title field**: Uses selected language (ML/AR/HI/EN)
- **Other fields**: Uses English (en-US)
- Requires internet connection

### 3. Barcode Scanning
- Uses `html5-qrcode` library
- Scans ISBN and fetches metadata from Open Library API
- Requires internet for metadata lookup

### 4. Multi-Language Support
| Code | Language | Font |
|------|----------|------|
| `en` | English | Noto Sans |
| `ml` | Malayalam | Noto Sans Malayalam |
| `ar` | Arabic | Noto Sans Arabic |
| `hi` | Hindi | Noto Sans Devanagari |

### 5. Search & Filter (Slicer)
- Universal search across all fields
- Sort by: Title, Author, Date, Price
- Export filtered results to CSV

### 6. Analytics Dashboard
- Total book count
- Asset value (grouped by currency)
- Language distribution (pie chart)
- Top publishers, locations, tags
- Books needing repair

### 7. Backup & Restore
- **Chunked backup**: Splits data into 9MB parts
- **Full backup**: Includes Base64 images
- **Text-only backup**: Excludes images
- **Visual folder picker** for restore
- **Restore metadata** tracking

### 8. Export Options
- **CSV**: Spreadsheet format
- **HTML Text**: Printable list
- **HTML Visual**: Catalogue with covers

---

## Capacitor Plugins Used

| Plugin | Purpose |
|--------|---------|
| `@capacitor/core` | Core framework |
| `@capacitor/android` | Android platform |
| `@capacitor/app` | Back button handling |
| `@capacitor/filesystem` | File read/write |
| `@capacitor/preferences` | Key-value storage |
| `@capacitor-community/speech-recognition` | Voice input |
| `@capawesome/capacitor-file-picker` | Folder selection |

---

## Offline Capabilities

| Feature | Offline? | Notes |
|---------|----------|-------|
| View/Edit books | ✅ Yes | All local |
| Add new books | ✅ Yes | All local |
| Backup/Restore | ✅ Yes | Device filesystem |
| Camera photos | ✅ Yes | Device camera |
| Export CSV/HTML | ✅ Yes | Device storage |
| Barcode lookup | ❌ No | Uses Open Library API |
| Voice input | ❌ No | Uses Google Speech |
| Fonts | ✅ Yes | Bundled in APK |

---

## Build Process (Cloud Build)

1. **Install dependencies** (`npm install`)
2. **Prepare web assets**:
   - Create `www/` folder
   - Download JS libraries
   - Download font files
3. **Add Android platform** (`cap add android`)
4. **Inject permissions** (AndroidManifest.xml):
   - CAMERA
   - RECORD_AUDIO
   - READ/WRITE_EXTERNAL_STORAGE
   - MODIFY_AUDIO_SETTINGS
   - INTERNET
5. **Sync assets** (`cap sync android`)
6. **Build APK** (Gradle assembleDebug)

---

## File Structure

```
Shelflife/
├── index.html          # Single-file React app
├── package.json        # NPM dependencies
├── capacitor.config.json # Capacitor settings
├── cloudbuild.yaml     # Google Cloud Build pipeline
└── www/                # (Generated during build)
    ├── index.html
    ├── libs/           # Downloaded JS libraries
    └── fonts/          # Downloaded font files
```

---

## UX Enhancements

### Exit Confirmation
- Intercepts Android back button
- Shows "Do you want to exit?" dialog
- Uses `App.exitApp()` if confirmed

### Backup Reminder
- Tracks `lastBackupDate` and `entriesSinceBackup`
- Shows reminder after:
  - 7+ days since last backup, OR
  - 10+ new entries added
- Reminder shown once per session

### Restore Metadata
- Stores last restore info in localStorage
- Displays: "Last Restored: [filename] on [date]"

---

## Version History

| Date | Change |
|------|--------|
| 2024-12-24 | Native speech recognition plugin |
| 2024-12-24 | Visual folder picker for restore |
| 2024-12-24 | Bundled fonts for offline |
| 2024-12-24 | Exit confirmation + backup reminder |
| 2024-12-24 | CSV export from Library/Slicer views |

---

## Contact
**Developer**: Anees  
**App Name**: Home Library by Anees  
**Package ID**: com.shelflife.app
