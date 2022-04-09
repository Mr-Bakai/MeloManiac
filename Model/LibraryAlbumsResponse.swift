//
//  LibraryAlbumsResponse.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 9/4/22.
//

import Foundation

struct LibraryAlbumsResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let addedAt: String?
    let album: Album
}
