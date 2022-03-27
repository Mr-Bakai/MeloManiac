//
//  FeaturedPlaylistResponse.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 18/1/22.
//

import Foundation

struct FeaturedPlaylistResponse: Codable {
    let playlists: PlaylistResponse
}

struct CategoryPlaylistResponse: Codable {
    let playlists: PlaylistResponse
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}

struct User: Codable{
    let display_name: String
    let external_urls: [String:String]
    let id: String
}
