//
//  Helper.swift
//  MediaFlow
//
//  Created by Arpana Rani on 22/04/26.
//

import Foundation

func localFilePath(for url: URL) -> URL {
    let fileName = url.lastPathComponent
    let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return documents.appendingPathComponent(fileName)
}
