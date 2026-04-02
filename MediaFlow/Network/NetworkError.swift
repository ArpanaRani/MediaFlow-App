//
//  NetworkError.swift
//  MediaFlow
//
//  Created by Arpana Rani on 01/04/26.
//


import Foundation

enum NetworkError: Error {
    case noDataAvailable
    case unableToDecodeData
    case invalidResponse
}
