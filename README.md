# MediaFlow 📱

MediaFlow is a SwiftUI-based iOS application that demonstrates two core concepts:

1. Media Browsing (Gallery) — fetching and displaying images using AsyncImage  
2. File Download System (Downloads) — implementing URLSessionDownloadTask with progress tracking, pause/resume using resumeData, and local file caching  

---

## Demo
<img width="400" height="815" alt="Screen Recording 2026-04-23 at 10 09 15 PM" src="https://github.com/user-attachments/assets/3571ae27-ec6e-4e0a-8cef-57c561bae960" />


## Screenshots
<img width="400" height="800" alt="Simulator Screenshot - iPhone 17 Pro - 2026-04-23 at 22 13 54" src="https://github.com/user-attachments/assets/e0f156c2-73f6-4baf-9b87-ad7adc4ed552" />


## 1.Why Two Separate Tabs?

MediaFlow separates functionality into two independent tabs:

 Gallery Tab
    Displays images from an API (Picsum)
    Focused on UI rendering and smooth scrolling
    Uses lightweight image loading (AsyncImage)
 Downloads Tab
  Demonstrates a full download system
  Supports:
    Progress tracking
    Pause / Resume
    Resume using resumeData
    Local file caching
## 2. Why Use a Static .dat File for Downloads?

The Downloads tab uses a hardcoded URL:

https://proof.ovh.net/files/100Mb.dat
 Reason: This file is used intentionally to demonstrate a reliable download system, not to display media.

Benefits of this file:
 * Supports HTTP byte-range requests (Accept-Ranges: bytes)
 * Enables pause and resume functionality
 * Large size (~100MB) → allows visible progress updates
 * No CDN redirects → ensures stable resume behavior
 * Reliable test server → consistent across environments

 ## 3. Why Not Use Image APIs for Downloads?

Typical image APIs (e.g., Picsum, Unsplash) are not suitable for demonstrating download systems because:

They use CDN redirects
Files are usually small → progress not meaningful
Resume support is unreliable
resumeData may not be generated correctly
All above reasons make pause/resume difficult to demonstrate reliably.

## 4. Why Show Random Images in Downloads Tab?

In the Downloads tab, a placeholder image is shown:
https://picsum.photos/seed/{id}/200/200
Reason:
 * The downloaded files are not images (they are .dat files)
 * To maintain a visually appealing UI, a random image is used as a placeholder
Purpose:
* Improves UI presentation
* Keeps layout consistent with the Gallery tab
* Clearly separates visual representation from actual file content
The image is purely decorative and does not represent the downloaded file.

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
  Gallery Tab
   ↓
 MediaItem (API Model)

 Downloads Tab
   ↓
 DownloadItem (State Model)
   ↓
 DownloadManager (URLSession)
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

