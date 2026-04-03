# MediaFlow 📱

MediaFlow is a SwiftUI-based iOS app that fetches media from an API and allows users to download images with real-time progress tracking.

---

## Demo
![ScreenRecording2026-04-03at6 28 58PM-ezgif com-crop](https://github.com/user-attachments/assets/0d4b70f6-98d8-4fd9-8ed1-8ef1902d441f)

## Screenshots
<img width="400" height="900" alt="Simulator Screenshot - iPhone 17 Pro - 2026-04-03 at 18 07 20" src="https://github.com/user-attachments/assets/6c19559e-4cd5-4f75-91c1-1067a2f34dd4" />


##  Features

* Fetch media from API
* Display thumbnails using AsyncImage
* Download images with progress indicator
* Retry failed downloads
* Show completed download state
* Dynamic UI updates using MVVM

---

##  Architecture

* **MVVM Pattern**
* **DownloadManager** using `URLSessionDownloadDelegate`
* State-driven UI using `DownloadState`

---

##  Download Flow
Tap Download → Start Task → Track Progress → Complete / Fail → UI Updates

---

## Tech Stack
* Swift
* SwiftUI
* URLSession
* MVVM

---

##  Future Improvements
*  Pause / Resume downloads
*  Implement caching mechanism for downloaded media

