//
//  AlbumDetailsResponse.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 23/1/22.
//

import Foundation

struct AlbumDetailsResponse: Codable {
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let label: String
      let tracks: TracksResponse
}

struct TracksResponse: Codable {
    let items: [AudioTrack]
}
