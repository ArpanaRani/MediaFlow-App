//
//  DownloadState.swift
//  MediaFlow
//
//  Created by Arpana Rani on 01/04/26.
//

import Foundation

enum DownloadState {
    case notStarted
    case downloading(progress: Double)
    case completed(localURL: URL)
    case failed
}
