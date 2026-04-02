//
//  MediaItem.swift
//  MediaFlow
//
//  Created by Arpana Rani on 01/04/26.
//


struct MediaItem: Identifiable, Decodable {
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}