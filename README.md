# Snapchat Memories Exporter

A native macOS application for downloading and archiving your Snapchat Memories with proper organization and metadata preservation.

## Overview

Snapchat Memories Exporter is a Swift-based macOS app that allows you to download all your Snapchat memories from your data export. The app automatically organizes files by date, preserves location metadata, and provides detailed progress tracking during downloads.

## Features

- **Automatic Date Organization**: Files are organized into folders by year-month (e.g., `2025-10/`, `2025-09/`)
- **Metadata Preservation**: Each file includes a companion JSON file with original date, location coordinates, and media type
- **File Timestamp Correction**: Sets actual file creation/modification dates to match the original Snapchat timestamp
- **Progress Tracking**: Real-time progress bar with success/failure counts
- **Error Handling**: Detailed reporting of failed downloads with the ability to review which files failed
- **Batch Processing**: Downloads all memories automatically with rate limiting to avoid overwhelming servers

## Requirements

- macOS 13.0 (Ventura) or later
- Active Snapchat account with data export access

## Installation

### Download Pre-built App

1. Go to the [Releases](https://github.com/jackfpaylor/snapchat-memories-exporter/releases) page
2. Download `snap_memory_saver.app.zip` from the latest release
3. Unzip the file (double-click it)
4. Move `snap_memory_saver.app` to your Applications folder (optional but recommended)
5. **Important**: Right-click on the app and select "Open" (required for first launch)
6. Click "Open" in the security dialog that appears
7. The app will now run normally

### Building from Source

If you prefer to build the app yourself:

1. Clone the repository:
```bash
git clone https://github.com/jackfpaylor/snapchat-memories-exporter.git
cd snapchat-memories-exporter
```

2. Open the project in Xcode:
```bash
open snap_memory_saver.xcodeproj
```

3. Build and run the project:
   - Select your Mac as the target device
   - Press `Cmd + R` or click the "Run" button
   - Requires Xcode 14.0 or later

## Getting Your Snapchat Data

Before using this app, you need to request your data from Snapchat. Follow these steps carefully:

### Step 1: Request Your Data from Snapchat

1. **Open Snapchat** on your phone (iPhone or Android)
2. **Tap your profile picture** in the top-left corner of the screen
3. **Tap the settings gear icon** ⚙️ in the top-right corner
4. **Scroll down** and tap on **"My Data"**
5. **Tap "Submit Request"** at the bottom of the screen

### Step 2: Choose the Right Export Options

This is important - you need to select specific options:

1. **Select what data to include:**
   - Make sure **"Memories"** is checked ✓
   - You can uncheck other items if you only want your memories

2. **IMPORTANT: Choose the file format:**
   - Look for the option that says **"Export JSON Files"**
   - The full text will say: **"Export JSON Files - For data portability purposes"**
   - **Tap this option to select it** (this is required for the app to work)
   - Do NOT select "HTML only" - the app needs the JSON files

3. **Tap "Submit Request"** at the bottom

### Step 3: Wait for Your Data

- Snapchat will email you when your data is ready (usually within 24 hours)
- The email subject will be something like "Your Snapchat Data is Ready"
- The email will contain a download link

### Step 4: Download and Unzip Your Data

1. **Click the download link** in the email from Snapchat
2. **Save the ZIP file** to your computer (it will be a large file)
3. **Double-click the ZIP file** to unzip it
4. You'll see a folder with your Snapchat data inside

### Step 5: Find the memories_history.json File

1. **Open the unzipped folder** from Snapchat
2. **Look for a folder named "json"** and open it
3. **Find the file named exactly:** `memories_history.json`
4. **Remember where this file is** - you'll need to select it in the app

**Important Notes:**
- The file MUST be named exactly `memories_history.json` (if you don't see this file, you may have selected the wrong export option in Step 2)
- Download links in the file expire after a few days, so use the app soon after downloading your data
- If links expire, you'll need to request a fresh data export from Snapchat

## Using the App

### Step 1: Launch the App

1. **Open the Snapchat Memories Exporter app** from your Applications folder
2. You'll see a window with two main steps

### Step 2: Select Your JSON File

1. **Click the "Choose File" button**
2. **Navigate to where you unzipped your Snapchat data**
3. **Go into the "json" folder**
4. **Select the file named `memories_history.json`**
5. **Click "Open"**

The app will show you how many memories were found (e.g., "11,916 memories found")

### Step 3: Choose Where to Save Your Memories

1. **Click the "Choose Folder" button**
2. **Select a folder** where you want your memories saved (like Desktop, Documents, or an external drive)
3. **Click "Choose Folder"**

Tip: Make sure you have enough space - memories can take up several gigabytes!

### Step 4: Download Your Memories

1. **Click "Download All Memories"**
2. Watch the progress bar as your memories download
3. The app will show you:
   - How many files have been downloaded successfully
   - How many failed (if any)
   - Which file is currently downloading

### Step 5: Review Your Downloaded Memories

When the download finishes:
- **Green message**: All files downloaded successfully!
- **Orange message with "View Failed" button**: Some files failed to download (usually because download links expired)

**If you see failed downloads:**
1. Click "View Failed" to see which files didn't download
2. The most common reason is expired download links
3. To fix this, request a fresh data export from Snapchat and try again

## What You'll Get

Your memories will be organized in folders by date:
```
Your Chosen Folder/
├── 2025-10/
│   ├── 2025-10-05_05-01-04.jpg        (your photo)
│   ├── 2025-10-05_05-01-04.json       (information about the photo)
│   ├── 2025-10-04_23-08-19.jpg
│   └── 2025-10-04_23-08-19.json
├── 2025-09/
│   ├── 2025-09-20_06-05-48.mp4        (your video)
│   └── 2025-09-20_06-05-48.json       (information about the video)
└── Unknown_Date/
    └── (any files without dates)
```

### What's in the JSON Files?

Each photo or video has a small JSON file next to it with information like:
- The exact date and time it was taken
- GPS coordinates (if you had location enabled)
- Whether it's a photo or video

You can ignore these JSON files if you just want your photos and videos.

## Common Issues and Solutions

### "I can't find the memories_history.json file"

**Problem**: You probably didn't select "Export JSON Files" when requesting your data.

**Solution**: 
1. Go back to Snapchat
2. Request your data again
3. Make sure to select "Export JSON Files - For data portability purposes"
4. Wait for the new download link

### "All my downloads are failing"

**Problem**: The download links in your data export have expired.

**Solution**: 
1. Request a fresh data export from Snapchat
2. Download it as soon as you get the email
3. Use this app within a few days of downloading

### "The app won't open"

**Problem**: macOS is blocking the app because it's not from the App Store.

**Solution**: 
1. Don't double-click the app
2. Right-click (or Control + click) on the app
3. Select "Open" from the menu
4. Click "Open" in the dialog box
5. After doing this once, you can double-click to open it normally

### "I'm getting a permission error"

**Problem**: The app needs permission to read your files and save to folders.

**Solution**: 
1. When the app asks for permission, click "Allow"
2. If you clicked "Don't Allow" by accident, go to:
   - System Settings > Privacy & Security > Files and Folders
   - Find the Snapchat Memories Exporter app
   - Turn on the permissions

## Technical Details

### Rate Limiting

The app includes a 100ms delay between downloads to avoid overwhelming Snapchat's servers and to maintain stable download speeds.

### Error Handling

The app handles various error scenarios:
- Invalid or malformed URLs
- Expired download links (403/404 responses)
- Network timeouts
- Connection failures
- File system errors

### Security

- Uses security-scoped resources for file access (required on macOS)
- No data is collected or transmitted except to download your memories
- All processing happens locally on your machine

## Privacy

This application:
- Does not collect any user data
- Does not transmit data to any third-party servers
- Only communicates with Snapchat's servers to download your memories
- Operates entirely offline except for downloading files
- All your data stays on your computer

## Known Limitations

- Download links in Snapchat data exports expire after a short period
- Cannot download memories if they have been deleted from Snapchat
- Requires macOS 13.0 or later
- Large exports (10,000+ memories) may take significant time to download

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Guidelines

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/YourFeature`)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (`git push origin feature/YourFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you encounter issues or have questions:
1. Check the [Common Issues and Solutions](#common-issues-and-solutions) section
2. Search existing [Issues](https://github.com/jackfpaylor/snapchat-memories-exporter/issues)
3. Create a new issue with detailed information about your problem

## Disclaimer

This application is not affiliated with, endorsed by, or sponsored by Snap Inc. Snapchat is a registered trademark of Snap Inc.
