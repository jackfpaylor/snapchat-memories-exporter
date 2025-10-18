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
- Xcode 14.0 or later (for building from source)
- Active Snapchat account with data export access

## Installation

### Option 1: Build from Source

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

### Option 2: Download Pre-built App

Pre-built releases are available on the [Releases](https://github.com/jackfpaylor/snapchat-memories-exporter/releases) page.

## Getting Your Snapchat Data

Before using this app, you need to request your data from Snapchat:

1. Open Snapchat on your mobile device
2. Tap your profile icon in the top-left corner
3. Tap the settings gear icon in the top-right corner
4. Scroll down to "My Data"
5. Tap "Submit Request"
6. Select the data you want to include (make sure "Memories" is checked)
7. Choose "JSON" as the file format
8. Tap "Submit Request"

Snapchat typically processes data requests within 24 hours. You'll receive an email when your data is ready to download.

**Important Notes:**
- Download links in the JSON export expire after a short period (typically a few days)
- If you see many failed downloads, you may need to request a fresh data export
- The app requires the `memories_history.json` file from your Snapchat data export

## Usage

### Step 1: Prepare Your Data

1. Download your Snapchat data export from the link in your email
2. Unzip the downloaded file
3. Locate the `memories_history.json` file in the `json` folder

### Step 2: Run the Application

1. Launch the Snapchat Memories Exporter app
2. Click "Choose File" and select your `memories_history.json` file
3. The app will display how many memories were found
4. Click "Choose Folder" to select where you want to save your memories
5. Click "Download All Memories" to begin the download process

### Step 3: Monitor Progress

The app will display:
- Real-time progress bar
- Current file being downloaded
- Success and failure counts
- Overall completion status

### Step 4: Review Results

After downloading completes:
- Successfully downloaded files will be organized in date-based folders
- If any downloads failed, you can click "View Failed" to see which files had issues
- Failed downloads typically indicate expired download links

## Output Structure

Downloaded files are organized as follows:
```
Output Folder/
├── 2025-10/
│   ├── 2025-10-05_05-01-04.jpg
│   ├── 2025-10-05_05-01-04.json
│   ├── 2025-10-04_23-08-19.jpg
│   └── 2025-10-04_23-08-19.json
├── 2025-09/
│   ├── 2025-09-20_06-05-48.mp4
│   └── 2025-09-20_06-05-48.json
└── Unknown_Date/
    └── (files without parseable dates)
```

### Metadata Format

Each media file has a companion JSON file containing:
```json
{
  "Date": "2025-10-05 05:01:04 UTC",
  "Download Link": "https://...",
  "Latitude": 32.811264,
  "Location": "Latitude, Longitude: 32.811264, -96.76935",
  "Longitude": -96.76935,
  "Media Type": "Image"
}
```

## Troubleshooting

### "Failed to parse JSON" Error

**Cause**: The app cannot access the selected JSON file.

**Solution**: Make sure the file is not open in another application and that you have read permissions.

### All Downloads Failing

**Cause**: Download links in your data export have expired.

**Solution**: Request a fresh data export from Snapchat. Download links typically expire after a few days.

### Some Downloads Failing

**Cause**: Individual download links may have expired or network issues occurred.

**Solution**: 
- Review the failed files list to see which memories couldn't be downloaded
- Request a new data export if many files are failing
- Check your internet connection

### Permission Issues

**Cause**: macOS security restrictions preventing file access.

**Solution**: When prompted, grant the app permission to access files and folders. You can also check System Settings > Privacy & Security > Files and Folders.

## Project Structure
```
snap_memory_saver/
├── snap_memory_saverApp.swift    # App entry point
├── ContentView.swift              # Main UI
├── Models.swift                   # Data models
├── DownloadManager.swift          # Download logic
├── FolderPicker.swift            # Folder selection UI
└── FailedFilesView.swift         # Failed files display
```

## Development

### Building the Project

1. Ensure you have Xcode 14.0 or later installed
2. Clone the repository
3. Open `snap_memory_saver.xcodeproj` in Xcode
4. Select your Mac as the target
5. Build and run with `Cmd + R`

### Key Dependencies

- SwiftUI for the user interface
- Combine for reactive state management
- Foundation for networking and file operations

No external dependencies or package managers required.

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

## Acknowledgments

- Built with Swift and SwiftUI
- Designed for macOS Ventura and later

## Support

If you encounter issues or have questions:
1. Check the [Troubleshooting](#troubleshooting) section
2. Search existing [Issues](https://github.com/jackfpaylor/snapchat-memories-exporter/issues)
3. Create a new issue with detailed information about your problem

## Disclaimer

This application is not affiliated with, endorsed by, or sponsored by Snap Inc. Snapchat is a registered trademark of Snap Inc.
